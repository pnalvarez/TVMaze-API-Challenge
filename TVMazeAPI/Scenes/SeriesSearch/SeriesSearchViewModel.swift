//
//  SeriesSearchViewModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import Foundation
import Combine

protocol SeriesSearchViewModelable {
  var seriesItemPublisher: AnyPublisher<SeriesDisplayModel, Never> { get }
  var loadingPublisher: AnyPublisher<Bool, Never> { get }
  var errorPublisher: AnyPublisher<String, Never> { get }
  var buttonEnabledPublisher: AnyPublisher<Bool, Never> { get }
  func didTapSearch(_ query: String)
  func didChangeTextField(_ query: String)
}

final class SeriesSearchViewModel: SeriesSearchViewModelable {
  var seriesItemPublisher: AnyPublisher<SeriesDisplayModel, Never> {
    seriesItemSubject.eraseToAnyPublisher()
  }
  
  var loadingPublisher: AnyPublisher<Bool, Never> {
    loadingSubject.eraseToAnyPublisher()
  }
  
  var errorPublisher: AnyPublisher<String, Never> {
    errorSubject.eraseToAnyPublisher()
  }
  
  var buttonEnabledPublisher: AnyPublisher<Bool, Never> {
    buttonEnabledSubject.eraseToAnyPublisher()
  }
  
  private var subscription: AnyCancellable?
  
  private lazy var loadingSubject: PassthroughSubject<Bool, Never> = .init()
  private lazy var errorSubject: PassthroughSubject<String, Never> = .init()
  private lazy var seriesItemSubject: PassthroughSubject<SeriesDisplayModel, Never> = .init()
  private lazy var buttonEnabledSubject: PassthroughSubject<Bool, Never> = .init()
  
  private let service: SeriesSearchServicing
  
  init(service: SeriesSearchServicing = SeriesSearchService()) {
    self.service = service
  }
  
  func didChangeTextField(_ query: String) {
    buttonEnabledSubject.send(!query.isEmpty)
  }
  
  func didTapSearch(_ query: String) {
    loadingSubject.send(true)
    subscription = service
      .fetchSingleSearch(query: query)
      .map(convertToDisplayModel)
      .sink(receiveCompletion: { [weak self] in
        self?.loadingSubject.send(false)
        if case let .failure(error) = $0 {
          self?.errorSubject.send(error.localizedDescription)
        }
      }, receiveValue: { [weak self] in
        self?.loadingSubject.send(false)
        self?.seriesItemSubject.send($0)
      })
  }
  
  private func convertToDisplayModel(_ model: SeriesModel) -> SeriesDisplayModel {
    SeriesDisplayModel(id: model.id, imageURL: URL(string: model.image.medium), title: model.name)
  }
}
