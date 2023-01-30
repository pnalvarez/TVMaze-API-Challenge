//
//  FavoriteSeriesFactory.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

enum FavoriteSeriesFactory {
  static func build() -> FavoriteSeriesViewController {
    FavoriteSeriesViewController(viewModel: FavoriteSeriesViewModel())
  }
}
