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
  func removeFromFavorite(index: Int)
  func saveAlertShown()
}

final class FavoriteSeriesViewModel: FavoriteSeriesViewModelable {
  typealias Dependencies = HasPersistencyManager

  private let dependencies: Dependencies
  
  private lazy var updateUISubject: PassthroughSubject<Void, Never> = .init()
  
  var favoriteSeries: [SeriesDisplayModel] {
    let favorite = dependencies.persistencyManager.getFavorite()
    let displayModel = favorite.map { SeriesDisplayModel(id: $0.id, imageURL: URL(string: $0.image.medium), title: $0.name)}
    return displayModel
  }
  
  var firstTimeScreenShown: Bool {
    dependencies.persistencyManager.checkAlertShown()
  }
  
  var updateUIPublisher: AnyPublisher<Void, Never> {
    updateUISubject.eraseToAnyPublisher()
  }
  
  init(dependencies: Dependencies = DependencyContainer()) {
    self.dependencies = dependencies
  }
  
  func removeFromFavorite(index: Int) {
    let id = favoriteSeries[index].id
    dependencies.persistencyManager.removeFromFavorite(withId: id)
    updateUISubject.send()
  }
  
  func saveAlertShown() {
    dependencies.persistencyManager.saveFirstTimeAlertShown()
  }
}
