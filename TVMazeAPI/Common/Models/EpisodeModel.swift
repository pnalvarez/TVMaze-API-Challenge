//
//  EpisodeModel.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

struct EpisodeModel: Decodable {
  let id: Int
  let name: String
  let season: Int
  let number: Int
  let summary: String
  let image: ImageModel
}
