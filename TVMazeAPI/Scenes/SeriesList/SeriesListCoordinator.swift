//
//  SeriesListCoordinator.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import UIKit

enum SeriesListNavigationItem {
  case details(_ id: Int)
}

protocol SeriesListCoordinating {
  func navigateTo(_ item: SeriesListNavigationItem)
}

final class SeriesListCoordinator: SeriesListCoordinating {
  weak var viewController: UIViewController?
  
  private func navigateToDetails(_ id: Int) {
    let detailsController = SeriesDetailsFactory.build(id)
    viewController?.navigationController?.pushViewController(detailsController, animated: true)
  }
  
  func navigateTo(_ item: SeriesListNavigationItem) {
    switch item {
    case let .details(id):
      navigateToDetails(id)
    }
  }
}
