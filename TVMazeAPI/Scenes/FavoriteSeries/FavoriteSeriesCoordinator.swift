//
//  FavoriteSeriesCoordinator.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import UIKit

enum FavoriteSeriesNavigationItem {
  case details(id: Int)
}

protocol FavoriteSeriesCoordinating {
  func navigateTo(_ item: FavoriteSeriesNavigationItem)
}

final class FavoriteSeriesCoordinator: FavoriteSeriesCoordinating {
  weak var viewController: UIViewController?
  
  private func navigateToDetails(id: Int) {
    let detailsController = SeriesDetailsFactory.build(id)
    viewController?.navigationController?.pushViewController(detailsController, animated: true)
  }
  
  func navigateTo(_ item: FavoriteSeriesNavigationItem) {
    switch item {
    case let .details(id):
      navigateToDetails(id: id)
    }
  }
}
