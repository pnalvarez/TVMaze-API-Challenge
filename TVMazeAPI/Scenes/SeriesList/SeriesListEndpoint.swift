//
//  SeriesListEndpoint.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import Foundation

enum SeriesListEndpoint: EndpointExposable {
  case seriesList(page: Int)
  
  var path: String {
    "/shows"
  }
  
  var httpMethod: HTTPMethod {
    .GET
  }
  
  var headers: [String : String]? {
    nil
  }
  
  var body: Data? {
    nil
  }
}
