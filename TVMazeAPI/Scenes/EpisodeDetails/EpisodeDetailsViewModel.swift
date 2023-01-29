//
//  EpisodeDetailsViewModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import Foundation

protocol EpisodeDetailsViewModelable {
  var episodeDisplayModel: EpisodeDetailsDisplayModel { get }
}

final class EpisodeDetailsViewModel: EpisodeDetailsViewModelable {
  private enum Strings {
    static let nameFormat = "Name: %@"
    static let summaryFormat = "Summary: %@"
    static let seasonFormat = "Season %@"
    static let numberFormat = "Episode number %@"
  }
  var episodeDisplayModel: EpisodeDetailsDisplayModel {
    EpisodeDetailsDisplayModel(image: URL(string: episodeModel.image.medium),
                               name: String(format: Strings.nameFormat, episodeModel.name),
                               summary: String(format: Strings.summaryFormat, episodeModel.summary),
                               season: String(format: Strings.seasonFormat, String(episodeModel.season)),
                               number: String(format: Strings.numberFormat, String(episodeModel.number)))
  }
  
  private let episodeModel: EpisodeModel
  
  init(episodeModel: EpisodeModel) {
    self.episodeModel = episodeModel
  }
}
