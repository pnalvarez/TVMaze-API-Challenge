//
//  EndpointExposable.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import Foundation

protocol EndpointExposable {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String : String]? { get }
    var body: Data? { get }
}
