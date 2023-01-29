//
//  EpisodeDetailsFactory.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

enum EpisodeDetailsFactory {
  static func build(_ episode: EpisodeModel) -> EpisodeDetailsViewController {
    EpisodeDetailsViewController(viewModel: EpisodeDetailsViewModel(episodeModel: episode))
  }
}
