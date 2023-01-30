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
  var isFavoritePublisher: AnyPublisher<Void, Never> { get }
  var buttonTitle: String { get }
  func viewDidLoad()
  func didClickEpisode(_ season: Int, _ number: Int)
  func didTapFavoriteButton()
}

final class SeriesDetailsViewModel: SeriesDetailsViewModelable {
  typealias Dependencies = HasPersistencyManager
  
  private enum Strings {
    static let episodeError = "It was not possible to fetch episode details"
    static let favoriteTitle = "Set as favorite"
    static let unfavorite = "Unfavorite"
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
  
  var isFavoritePublisher: AnyPublisher<Void, Never> {
    isFavoriteSubject.eraseToAnyPublisher()
  }
  
  var buttonTitle: String {
    isFavorite ? Strings.unfavorite : Strings.favoriteTitle
  }
  
  private lazy var loadingSubject: PassthroughSubject<Bool, Never> = .init()
  private lazy var dataSubject: PassthroughSubject<SeriesDetailsDisplayModel, Never> = .init()
  private lazy var errorSubject: PassthroughSubject<String, Never> = .init()
  private lazy var isFavoriteSubject: PassthroughSubject<Void, Never> = .init()
  
  private var seasonsList: EpisodeListDisplayModel?
  private var subscriptions: Set<AnyCancellable> = .init()
  private var seriesModel: SeriesModel?
  
  private(set) var isFavorite: Bool = false
  
  private let id: Int
  private let service: SeriesDetailsServicing
  private let coordinator: SeriesDetailsCoordinating
  private let dependencies: Dependencies
  
  init(id: Int,
       service: SeriesDetailsServicing = SeriesDetailsService(),
       coordinator: SeriesDetailsCoordinating,
       dependencies: Dependencies = DependencyContainer()) {
    self.id = id
    self.service = service
    self.coordinator = coordinator
    self.dependencies = dependencies
  }
  
  func viewDidLoad() {
    isFavorite = dependencies.persistencyManager.isFavorite(id: id)
    isFavoriteSubject.send()
    loadingSubject.send(true)
    service
      .fetchSeriesDetails(id)
      .sink(receiveCompletion: { [weak self] in
        self?.loadingSubject.send(false)
        if case let .failure(error) = $0 {
          self?.errorSubject.send(error.localizedDescription)
        }
      }, receiveValue: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.seriesModel = SeriesModel(id: $0.id, name: $0.name, image: $0.image)
        let displayModel = strongSelf.convertModelToDisplay($0)
        strongSelf.loadingSubject.send(false)
        strongSelf.seasonsList = displayModel.seasons
        strongSelf.dataSubject.send(displayModel)
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
  
  func didTapFavoriteButton() {
    guard let seriesModel else { return }
    isFavorite ? dependencies.persistencyManager.removeFromFavorite(withId: seriesModel.id) : dependencies.persistencyManager.saveAsFavorite(seriesModel)
    isFavorite.toggle()
    isFavoriteSubject.send()
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
                                            schedule: "Schedule: Aired \(model.schedule.days.joined(separator: " , ")) at \(model.schedule.time)",
                                            genres: "Genres: \(model.genres.joined(separator: " , "))",
                                            summary: "Summary: \(model.summary)",
                                            seasons: .init(episodes: seasons))
    return details
  }
}
