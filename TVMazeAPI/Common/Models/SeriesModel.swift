//
//  SeriesModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

struct SeriesModel: Decodable {
  let id: Int
  let name: String
  let image: SeriesImageModel
}

struct SeriesImageModel: Decodable {
  let medium: String
}
