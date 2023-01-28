//
//  SeriesListService.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import Foundation
import Combine

protocol SeriesListServicing {
  func fetchSeries(page: Int) -> AnyPublisher<[SeriesModel], Error>
}

final class SeriesListService: SeriesListServicing {
  func fetchSeries(page: Int) -> AnyPublisher<[SeriesModel], Error> {
    API<[SeriesModel]>()
      .fetchData(SeriesListEndpoint.seriesList(page: page))
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
