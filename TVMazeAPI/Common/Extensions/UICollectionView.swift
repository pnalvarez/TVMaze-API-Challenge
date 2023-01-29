//
//  UICollectionView.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import UIKit

extension UICollectionView {
  func registerCell<T: UICollectionViewCell>(cellType: T.Type) {
    self.register(cellType, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableCell <T: UICollectionViewCell>(indexPath: IndexPath, type: T.Type) -> T {
    let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    return cell
  }
}
