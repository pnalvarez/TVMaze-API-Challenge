//
//  FavoriteSeriesViewModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import Foundation
import Combine

protocol FavoriteSeriesViewModelable {
  var favoriteSeries: [SeriesDisplayModel] { get }
  var updateUIPublisher: AnyPublisher<Void, Never> { get }
  var firstTimeScreenShown: Bool { get }
  func fetchFavorite()
  func removeFromFavorite(index: Int)
  func saveAlertShown()
  func didSelectSeries(index: Int)
  func didSelectSortCriteria(_ tag: Int)
}

enum SortCriteria: Int {
  case id
  case alphabetically
}

final class FavoriteSeriesViewModel: FavoriteSeriesViewModelable {
  typealias Dependencies = HasPersistencyManager

  private let dependencies: Dependencies
  private let coordinator: FavoriteSeriesCoordinating
  
  private lazy var updateUISubject: PassthroughSubject<Void, Never> = .init()
  
  private var series: [SeriesModel] = []
  
  var favoriteSeries: [SeriesDisplayModel] {
    let displayModel = series.map { SeriesDisplayModel(id: $0.id, imageURL: URL(string: $0.image.medium), title: $0.name)}
    return displayModel
  }
  
  var firstTimeScreenShown: Bool {
    dependencies.persistencyManager.checkAlertShown()
  }
  
  var updateUIPublisher: AnyPublisher<Void, Never> {
    updateUISubject.eraseToAnyPublisher()
  }
  
  init(dependencies: Dependencies = DependencyContainer(),
       coordinator: FavoriteSeriesCoordinating) {
    self.dependencies = dependencies
    self.coordinator = coordinator
  }
  
  func fetchFavorite() {
    series = dependencies.persistencyManager.getFavorite()
    updateUISubject.send()
  }
  
  func removeFromFavorite(index: Int) {
    let id = favoriteSeries[index].id
    dependencies.persistencyManager.removeFromFavorite(withId: id)
    updateUISubject.send()
  }
  
  func saveAlertShown() {
    dependencies.persistencyManager.saveFirstTimeAlertShown()
  }
  
  func didSelectSeries(index: Int) {
    let id = favoriteSeries[index].id
    coordinator.navigateTo(.details(id: id))
  }
  
  func didSelectSortCriteria(_ tag: Int) {
    let criteria = SortCriteria(rawValue: tag) ?? .id
    switch criteria {
    case .id:
      series.sort(by: { $0.id < $1.id })
    case .alphabetically:
      series.sort(by: { $0.name < $1.name })
    }
    updateUISubject.send()
  }
}
