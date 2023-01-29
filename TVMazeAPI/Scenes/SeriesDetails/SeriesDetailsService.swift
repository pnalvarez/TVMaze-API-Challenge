//
//  SeriesDetailsService.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import Foundation
import Combine

protocol SeriesDetailsServicing {
  func fetchSeriesDetails(_ id: Int) -> AnyPublisher<SeriesDetailsModel, Error>
}

final class SeriesDetailsService: SeriesDetailsServicing {
  func fetchSeriesDetails(_ id: Int) -> AnyPublisher<SeriesDetailsModel, Error> {
    let publisher: AnyPublisher<SeriesDetailsModel, Error> = API<SeriesDetailsModel>().fetchData(SeriesEndpoint.seriesDetails(id: id))
    return publisher
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
