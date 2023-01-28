//
//  API.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import Foundation
import Combine

protocol APIProtocol {
  associatedtype T: Decodable
  func fetchData(_ endpoint: EndpointExposable) -> AnyPublisher<T, Error>
}

enum APIError: Error {
  case urlError
  case genericError(_ description: String)
}

final class API<T: Decodable>: APIProtocol {
  private let basePath = "https://api.tvmaze.com"
  
  private func makeExtraHeaders(from endpoint: EndpointExposable) -> String? {
    var headerString = "?"
    guard var headers = endpoint.headers,
          let first = headers.first else {
      return nil
    }
    
    headerString += "\(first.key)=\(first.value)"
    headers.removeValue(forKey: first.key)
    
    for (key, value) in headers {
      headerString += "&\(key)=\(value)"
    }
    return headerString
  }
  
  func fetchData<T: Decodable>(_ endpoint: EndpointExposable) -> AnyPublisher<T, Error> {
    let path = basePath + endpoint.path + "\(String(describing: makeExtraHeaders(from: endpoint) ?? ""))"
    guard let url = URL(string: path) else {
      return Fail(error: APIError.urlError).eraseToAnyPublisher()
    }
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.httpMethod.rawValue
    request.httpBody = endpoint.body
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .mapError({
        APIError.genericError($0.localizedDescription)
      })
      .map(\.data)
      .decode(type: T.self, decoder: JSONDecoder())
      .handleEvents(receiveOutput: { print("Received output: \($0)")})
      .eraseToAnyPublisher()
  }
}
