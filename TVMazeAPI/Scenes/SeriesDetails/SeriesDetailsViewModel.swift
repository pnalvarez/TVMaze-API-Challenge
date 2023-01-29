//
//  SeriesDetailsViewModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import Combine

protocol SeriesDetailsViewModelable {
  var loadingPublisher: AnyPublisher<Bool, Never> { get }
  var dataPublisher: AnyPublisher<SeriesDetailsDisplayModel, Never> { get }
  var errorPublisher: AnyPublisher<String, Never> { get }
  var seasons: EpisodeListDisplayModel? { get }
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
  
  var seasons: EpisodeListDisplayModel? {
    seasonsList
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
    service
      .fetchSeriesDetails(id)
      .map(convertModelToDisplay)
      .sink(receiveCompletion: { [weak self] in
        if case let .failure(error) = $0 {
          self?.errorSubject.send(error.localizedDescription)
        }
      }, receiveValue: { [weak self] in
        self?.seasonsList = $0.seasons
        self?.dataSubject.send($0.details)
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
  
  private func convertModelToDisplay(_ model: SeriesDetailsModel) -> (details: SeriesDetailsDisplayModel, seasons: EpisodeListDisplayModel) {
    let details = SeriesDetailsDisplayModel(id: model.id,
                                            name: model.name,
                                            image: model.image,
                                            schedule: model.schedule,
                                            genres: model.genres,
                                            summary: model.summary)
    var seasons = [[EpisodeModel]]()
    let episodes = model._embedded.episodes.sorted(by: {
      if $0.season > $1.season {
        return true
      } else if $1.season > $0.season {
        return false
      } else {
        if $0.number > $1.number {
          return true
        } else {
          return false
        }
      }
    })
    guard !episodes.isEmpty else {
      return (details: details, seasons: .init(episodes: []))
    }
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
    return (details: details, seasons: .init(episodes: seasons))
  }
}
