//
//  SeriesListViewModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import Foundation
import Combine

protocol SeriesListViewModelable {
  var seriesItems: [SeriesDisplayModel] { get }
  var showErrorPublisher: AnyPublisher<String, Never> { get }
  var updateUIPublisher: AnyPublisher<Void, Never> { get }
  var loadingPublisher: AnyPublisher<Bool, Never> { get }
  func viewDidLoad()
  func didClickCell(_ index: Int)
  func willDisplayCells(_ indexes: [Int])
}

final class SeriesListViewModel: SeriesListViewModelable {
  @Published private var series: [SeriesDisplayModel] = []
  
  var seriesItems: [SeriesDisplayModel] {
    series
  }
  
  var showErrorPublisher: AnyPublisher<String, Never> {
    showErrorSubject.eraseToAnyPublisher()
  }
  
  var updateUIPublisher: AnyPublisher<Void, Never> {
    updateUISubject.eraseToAnyPublisher()
  }
  
  var loadingPublisher: AnyPublisher<Bool, Never> {
    loadingSubject.eraseToAnyPublisher()
  }
  
  // MARK: - Subjects
  private lazy var showErrorSubject: PassthroughSubject<String, Never> = .init()
  private lazy var updateUISubject: PassthroughSubject<Void, Never> = .init()
  private lazy var loadingSubject: PassthroughSubject<Bool, Never> = .init()
  
  private var currentPage: Int = 0
  private var subscriptions: Set<AnyCancellable> = .init()
  private var isFetching: Bool = false
  
  private let service: SeriesListServicing
  
  init(service: SeriesListServicing = SeriesListService()) {
    self.service = service
  }
  
  func viewDidLoad() {
    loadingSubject.send(true)
    fetchSeries()
  }
  
  func didClickCell(_ index: Int) {
    
  }
  
  func willDisplayCells(_ indexes: [Int]) {
    if !indexes.filter({ $0 > series.count - 20}).isEmpty && !isFetching {
      isFetching = true
      currentPage += 1
      fetchSeries()
    }
  }
  
  private func fetchSeries() {
    service
      .fetchSeries(page: currentPage)
      .map({ value in
        value.map({ SeriesDisplayModel(imageURL: URL(string: $0.image.medium), title: $0.name)})
      })
      .scan(series, appendSeries)
      .sink(receiveCompletion: { [weak self] result in
        self?.isFetching = false
        self?.loadingSubject.send(false)
        if case let .failure(error) = result {
          self?.showErrorSubject.send(error.localizedDescription)
        }
      }, receiveValue: { [weak self] value in
        self?.isFetching = false
        self?.loadingSubject.send(false)
        self?.series = value
        self?.updateUISubject.send()
        print("Total of series: \(value.count)")
      })
      .store(in: &subscriptions)
  }
  
  private func appendSeries(_ arr1: [SeriesDisplayModel], _ arr2: [SeriesDisplayModel]) -> [SeriesDisplayModel] {
    var arr = [SeriesDisplayModel]()
    arr.append(contentsOf: arr1)
    arr.append(contentsOf: arr2)
    return arr
  }
}
