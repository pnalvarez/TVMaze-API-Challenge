//
//  SeriesDetailsDisplayModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import Foundation

struct SeriesDetailsDisplayModel {
  let id: Int
  let name: String
  let image: URL?
  let schedule: String
  let genres: String
  let summary: String
  let seasons: EpisodeListDisplayModel
}
