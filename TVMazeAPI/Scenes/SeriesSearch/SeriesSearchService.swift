//
//  SeriesSearchService.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import Foundation
import Combine

protocol SeriesSearchServicing {
  func fetchSearch(query: String) -> AnyPublisher<[SeriesSearchModel], Error>
  func fetchSingleSearch(query: String) -> AnyPublisher<SeriesModel, Error>
}

final class SeriesSearchService: SeriesSearchServicing {
  func fetchSearch(query: String) -> AnyPublisher<[SeriesSearchModel], Error> {
    let publisher: AnyPublisher<[SeriesSearchModel], Error> = API<[SeriesSearchModel]>()
      .fetchData(SeriesEndpoint.search(query: query))
    return publisher
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  func fetchSingleSearch(query: String) -> AnyPublisher<SeriesModel, Error> {
    let publisher: AnyPublisher<SeriesModel, Error> = API<SeriesModel>()
      .fetchData(SeriesEndpoint.singleSearch(query: query))
    return publisher
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
