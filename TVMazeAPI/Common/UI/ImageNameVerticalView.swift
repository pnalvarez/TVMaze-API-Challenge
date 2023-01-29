//
//  ImageNameVerticalView.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import UIKit
import SDWebImage

final class ImageNameVerticalView: UIView {
  private enum Constants {
    static let imageTop: CGFloat = 16
    static let margins: CGFloat = 16
    static let labelTop: CGFloat = 12
    static let labelBottom: CGFloat = -16
  }
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.borderWidth = 1
    layer.cornerRadius = 8
    buildView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setContent(_ viewModel: SeriesDisplayModel) {
    imageView.sd_setImage(with: viewModel.imageURL)
    titleLabel.text = viewModel.title
  }
  
  func reset() {
    imageView.image = nil
    titleLabel.text = ""
  }
}

extension ImageNameVerticalView: ViewCodable {
  func buildViewHierarchy() {
    addSubview(imageView)
    addSubview(titleLabel)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.imageTop),
      imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.margins),
      imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: Constants.margins),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.labelTop),
      titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
      titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.margins),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: Constants.margins),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.labelBottom),
    ])
  }
}
