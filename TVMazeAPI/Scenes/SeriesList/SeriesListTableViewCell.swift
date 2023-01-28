//
//  SeriesListTableViewCell.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import UIKit

final class SeriesListTableViewCell: UITableViewCell {
  private lazy var mainView: ImageLabelView = {
    let view = ImageLabelView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    buildView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateContent(imageURL: URL?, title: String) {
    mainView.updateContent(.init(imageURL: imageURL, title: title))
  }
}

extension SeriesListTableViewCell: ViewCodable {
  func buildViewHierarchy() {
    addSubview(mainView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      mainView.topAnchor.constraint(equalTo: topAnchor),
      mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
      mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
      mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
