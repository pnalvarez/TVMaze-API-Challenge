//
//  SeriesListFactory.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

enum SeriesListFactory {
  static func build() -> SeriesListViewController {
    let coordinator = SeriesListCoordinator()
    let viewModel = SeriesListViewModel(coordinator: coordinator)
    let viewController = SeriesListViewController(viewModel: viewModel)
    coordinator.viewController = viewController
    return viewController
  }
}
