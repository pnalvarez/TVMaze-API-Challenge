//
//  SeriesListEndpoint.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import Foundation

enum SeriesEndpoint: EndpointExposable {
  case seriesList(page: Int)
  case seriesDetails(id: Int)
  case search(query: String)
  case singleSearch(query: String)
  
  var path: String {
    switch self {
    case .seriesList:
      return "/shows"
    case let .seriesDetails(id):
      return "/shows/\(id)?embed=episodes"
    case .search:
      return "/search/shows"
    case .singleSearch:
      return "/singlesearch/shows"
    }
  }
  
  var httpMethod: HTTPMethod {
    .GET
  }
  
  var headers: [String : String]? {
    switch self {
    case let .seriesList(page):
      return ["page" : "\(page)"]
    case .seriesDetails:
      return nil
    case let .search(query):
      return ["q" : query]
    case let .singleSearch(query):
      return ["q" : query]
    }
  }
  
  var body: Data? {
    nil
  }
}
