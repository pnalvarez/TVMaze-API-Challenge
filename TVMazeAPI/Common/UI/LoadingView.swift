//
//  LoadingView.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import UIKit

final class LoadingView: UIActivityIndicatorView {
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    backgroundColor = .white
    tintColor = .blue
    color = .systemBlue
    hidesWhenStopped = true
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
