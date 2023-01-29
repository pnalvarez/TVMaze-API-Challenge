//
//  SeriesDetailsFactory.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

enum SeriesDetailsFactory {
  static func build(_ id: Int) -> SeriesDetailsViewController {
    let coordinator = SeriesDetailsCoordinator()
    let viewModel = SeriesDetailsViewModel(id: id,
                                           coordinator: coordinator)
    let viewController = SeriesDetailsViewController(viewModel: viewModel)
    coordinator.viewController = viewController
    return viewController
  }
}
