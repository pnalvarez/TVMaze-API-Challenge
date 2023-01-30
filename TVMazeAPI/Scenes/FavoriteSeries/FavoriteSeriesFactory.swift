//
//  FavoriteSeriesFactory.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

enum FavoriteSeriesFactory {
  static func build() -> FavoriteSeriesViewController {
    let coordinator = FavoriteSeriesCoordinator()
    let viewModel = FavoriteSeriesViewModel(coordinator: coordinator)
    let viewController = FavoriteSeriesViewController(viewModel: viewModel)
    coordinator.viewController = viewController
    return viewController
  }
}
