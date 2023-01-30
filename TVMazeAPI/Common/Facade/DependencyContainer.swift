//
//  DependencyContainer.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import Foundation

protocol HasDecoder {
  var jsonDecoder: JSONDecoder { get }
}

protocol HasPersistencyManager {
  var persistencyManager: PersistancyManagerInterface { get }
}

// Create one protocol to hold each dependency in order to mock the entire class

final class DependencyContainer: HasDecoder, HasPersistencyManager {
  lazy var jsonDecoder: JSONDecoder = JSONDecoder()
  lazy var persistencyManager: PersistancyManagerInterface = PersistencyManager.shared
}


