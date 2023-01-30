//
//  PersistencyManager.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import Foundation

protocol PersistancyManagerInterface {
  func saveAsFavorite(_ series: SeriesModel)
  func removeFromFavorite(withId id: Int)
  func getFavorite() -> [SeriesModel]
  func isFavorite(id: Int) -> Bool
  func saveFirstTimeAlertShown()
  func checkAlertShown() -> Bool
}

final class PersistencyManager: PersistancyManagerInterface {
  private enum Keys {
    static let favorite = "Favorite"
    static let isFavorite = "Is Favorite"
    static let alertShown = "Alert Shown"
  }
  
  private let userDefaults: UserDefaults = .standard
  static let shared = PersistencyManager()
  
  private init() { }

  func saveAsFavorite(_ series: SeriesModel) {
    guard let favoriteSeries = userDefaults.object(forKey: Keys.favorite) as? Data,
          var decoded = try? JSONDecoder().decode([SeriesModel].self, from: favoriteSeries) else {
      let favorite = [series]
      if let encoded = try? JSONEncoder().encode(favorite) {
        userDefaults.set(encoded, forKey: Keys.favorite)
      }
      userDefaults.set([series], forKey: Keys.favorite)
      return
    }
    guard decoded.first(where: { $0.id == series.id }) == nil else {
      return
    }
    decoded.append(series)
    guard let encoded = try? JSONEncoder().encode(decoded) else {
      return
    }
    userDefaults.set(encoded, forKey: Keys.favorite)
  }
  
  func removeFromFavorite(withId id: Int) {
    guard let favoriteSeries = userDefaults.object(forKey: Keys.favorite) as? Data,
          var decoded = try? JSONDecoder().decode([SeriesModel].self, from: favoriteSeries) else {
      return
    }
    decoded.removeAll(where: { $0.id == id })
    guard let encoded = try? JSONEncoder().encode(decoded) else {
      return
    }
    userDefaults.set(encoded, forKey: Keys.favorite)
  }
  
  func getFavorite() -> [SeriesModel] {
    guard let favoriteSeries = userDefaults.object(forKey: Keys.favorite) as? Data,
          let decoded = try? JSONDecoder().decode([SeriesModel].self, from: favoriteSeries) else {
      return []
    }
    return decoded
  }
  
  func isFavorite(id: Int) -> Bool {
    guard let favoriteSeries = userDefaults.object(forKey: Keys.favorite) as? Data,
          let decoded = try? JSONDecoder().decode([SeriesModel].self, from: favoriteSeries) else {
      return false
    }
    return decoded.contains { $0.id == id}
  }
  
  func saveFirstTimeAlertShown() {
    userDefaults.set(true, forKey: Keys.alertShown)
  }
  
  func checkAlertShown() -> Bool {
    return userDefaults.bool(forKey: Keys.alertShown)
  }
}
