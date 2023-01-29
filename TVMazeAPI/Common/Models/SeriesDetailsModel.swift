//
//  SeriesDetailsModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

struct SeriesDetailsModel: Decodable {
  let id: Int
  let name: String
  let image: ImageModel
  let schedule: ScheduleModel
  let genres: [String]
  let summary: String
  let _embedded: EmbeddedEpisodeModel
}

struct EmbeddedEpisodeModel: Decodable {
  let episodes: [EpisodeModel]
}

struct ScheduleModel: Decodable {
  let time: String
  let days: [String]
}
