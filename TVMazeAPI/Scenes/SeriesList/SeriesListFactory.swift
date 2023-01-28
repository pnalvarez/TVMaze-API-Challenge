//
//  SeriesListFactory.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

enum SeriesListFactory {
  static func build() -> SeriesListViewController {
    SeriesListViewController(viewModel: SeriesListViewModel())
  }
}
