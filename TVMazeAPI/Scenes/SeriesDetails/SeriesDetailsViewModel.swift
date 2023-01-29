//
//  SeriesDetailsViewModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import Foundation
import Combine

protocol SeriesDetailsViewModelable {
  var loadingPublisher: AnyPublisher<Bool, Never> { get }
  var dataPublisher: AnyPublisher<SeriesDetailsDisplayModel, Never> { get }
  var errorPublisher: AnyPublisher<String, Never> { get }
  func viewDidLoad()
  func didClickEpisode(_ season: Int, _ number: Int)
}

final class SeriesDetailsViewModel: SeriesDetailsViewModelable {
  private enum Strings {
    static let episodeError = "It was not possible to fetch episode details"
  }
  var loadingPublisher: AnyPublisher<Bool, Never> {
    loadingSubject.eraseToAnyPublisher()
  }
  
  var dataPublisher: AnyPublisher<SeriesDetailsDisplayModel, Never> {
    dataSubject.eraseToAnyPublisher()
  }
  
  var errorPublisher: AnyPublisher<String, Never> {
    errorSubject.eraseToAnyPublisher()
  }
  
  private lazy var loadingSubject: PassthroughSubject<Bool, Never> = .init()
  private lazy var dataSubject: PassthroughSubject<SeriesDetailsDisplayModel, Never> = .init()
  private lazy var errorSubject: PassthroughSubject<String, Never> = .init()
  
  private var seasonsList: EpisodeListDisplayModel?
  private var subscriptions: Set<AnyCancellable> = .init()
  
  private let id: Int
  private let service: SeriesDetailsServicing
  private let coordinator: SeriesDetailsCoordinating
  
  init(id: Int,
       service: SeriesDetailsServicing = SeriesDetailsService(),
       coordinator: SeriesDetailsCoordinating) {
    self.id = id
    self.service = service
    self.coordinator = coordinator
  }
  
  func viewDidLoad() {
    loadingSubject.send(true)
    service
      .fetchSeriesDetails(id)
      .map(convertModelToDisplay)
      .sink(receiveCompletion: { [weak self] in
        self?.loadingSubject.send(false)
        if case let .failure(error) = $0 {
          self?.errorSubject.send(error.localizedDescription)
        }
      }, receiveValue: { [weak self] in
        self?.loadingSubject.send(false)
        self?.seasonsList = $0.seasons
        self?.dataSubject.send($0)
      })
      .store(in: &subscriptions)
  }
  
  func didClickEpisode(_ season: Int, _ number: Int) {
    guard let episode = seasonsList?.episodes[season][number] else {
      errorSubject.send(Strings.episodeError)
      return
    }
    coordinator.navigateTo(.episodeDetails(episode))
  }
  
  private func convertModelToDisplay(_ model: SeriesDetailsModel) -> SeriesDetailsDisplayModel {
    var seasons = [[EpisodeModel]]()
    let episodes = model._embedded.episodes.sorted(by: {
      if $0.season > $1.season {
        return false
      } else if $1.season > $0.season {
        return true
      } else {
        if $0.number > $1.number {
          return false
        } else {
          return true
        }
      }
    })
    if !episodes.isEmpty  {
      seasons.append([])
      var season = 1
      for episode in episodes {
        if episode.season != season {
          seasons.append([episode])
          season+=1
        } else {
          seasons[seasons.count-1].append(episode)
        }
      }
    }
    let details = SeriesDetailsDisplayModel(id: model.id,
                                            name: "Name: \(model.name)",
                                            image: URL(string: model.image.medium),
                                            schedule: "Schedule: Aired \(model.schedule.days.joined(separator: ",")) at \(model.schedule.time)",
                                            genres: "Genres: \(model.genres.joined(separator: ","))",
                                            summary: "Summary \(model.summary)",
                                            seasons: .init(episodes: seasons))
    return details
  }
}
