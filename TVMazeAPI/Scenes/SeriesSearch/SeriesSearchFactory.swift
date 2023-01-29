//
//  SeriesSearchFactory.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

enum SeriesSearchFactory {
  static func build() -> SeriesSearchViewController {
    SeriesSearchViewController(viewModel: SeriesSearchViewModel())
  }
}
