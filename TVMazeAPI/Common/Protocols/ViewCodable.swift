//
//  ViewCodable.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import UIKit

protocol ViewCodable {
  func buildViewHierarchy()
  func setupConstraints()
  func configureViews()
}

extension ViewCodable {
  func configureViews() { }
  
  func buildView() {
    buildViewHierarchy()
    setupConstraints()
    configureViews()
  }
}
