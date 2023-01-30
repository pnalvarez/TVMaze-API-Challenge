
//  ImageLabelView.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import UIKit
import SDWebImage

final class ImageLabelView: UIView {
  // MARK: - ViewModel
  struct ViewModel {
    let imageURL: URL?
    let title: String
  }
  
  // MARK: - Constants
  private enum Constants {
    static let imageRadius: CGFloat = 8
    static let imageHeight: CGFloat = 64
    static let imageWidth: CGFloat = 48
    static let imageLeading: CGFloat = 16
    static let imageTop: CGFloat = 4
    static let imageBottom: CGFloat = -4
    static let labelLeading: CGFloat = 16
  }
  
  // MARK: - UI Properties
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = Constants.imageRadius
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateContent(_ viewModel: ViewModel) {
    imageView.sd_setImage(with: viewModel.imageURL)
    titleLabel.text = viewModel.title
  }
}

extension ImageLabelView: ViewCodable {
  func buildViewHierarchy() {
    addSubview(imageView)
    addSubview(titleLabel)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.imageLeading),
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.imageTop),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.imageBottom),
      imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
      imageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
      titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.labelLeading),
    ])
  }
}
