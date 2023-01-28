//
//  SeriesListViewModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import Combine

protocol SeriesListViewModelable {
  var seriesItems: [SeriesDisplayModel] { get }
  var showErrorPublisher: AnyPublisher<Void, Never> { get }
  var updateUIPublisher: AnyPublisher<Void, Never> { get }
  var loadingPublisher: AnyPublisher<Bool, Never> { get }
  func viewDidLoad()
  func didClickCell(_ index: Int)
  func willDisplayCells(_ indexes: [Int])
}
