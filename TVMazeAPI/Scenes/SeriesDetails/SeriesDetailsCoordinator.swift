//
//  SeriesDetailsCoordinator.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import UIKit

enum SeriesDetailsNavigationItem {
  case episodeDetails(_ model: EpisodeModel)
}

protocol SeriesDetailsCoordinating {
  func navigateTo(_ navigationItem: SeriesDetailsNavigationItem)
}

final class SeriesDetailsCoordinator: SeriesDetailsCoordinating {
  weak var viewController: UIViewController?
  
  private func navigateToEpisodeDetails(_ model: EpisodeModel) {
    // TO DO
  }
  
  func navigateTo(_ navigationItem: SeriesDetailsNavigationItem) {
    // TO DO
  }
}
