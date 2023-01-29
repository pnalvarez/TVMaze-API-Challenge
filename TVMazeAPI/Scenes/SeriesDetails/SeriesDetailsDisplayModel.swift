//
//  SeriesDetailsDisplayModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

struct SeriesDetailsDisplayModel {
  let id: Int
  let name: String
  let image: ImageModel
  let schedule: ScheduleModel
  let genres: [String]
  let summary: String
}
