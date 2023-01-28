//
//  UITableView.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import UIKit

extension UITableView {
  func registerCell<T: UITableViewCell>(cellType: T.Type) {
    self.register(cellType, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableCell <T: UITableViewCell>(indexPath: IndexPath, type: T.Type) -> T {
    let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    return cell
  }
}
