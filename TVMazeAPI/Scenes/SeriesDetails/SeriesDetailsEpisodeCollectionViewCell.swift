//
//  SeriesDetailsEpisodeCollectionViewCell.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import UIKit

final class SeriesDetailsEpisodeCollectionViewCell: UICollectionViewCell {
  private enum Constants {
    static let imageTop: CGFloat = 8
    static let leading: CGFloat = 8
    static let trailing: CGFloat = -8
    static let labelTop: CGFloat = 8
    static let labelBotton: CGFloat = -8
    static let imageWidth: CGFloat = 64
    static let imageHeight: CGFloat = 128
  }
  private lazy var posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 8
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 12)
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
  
  func setContent(_ url: URL?, _ title: String) {
    posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "loading-image"))
    titleLabel.text = title
  }
}

extension SeriesDetailsEpisodeCollectionViewCell: ViewCodable {
  func buildViewHierarchy() {
    addSubview(posterImageView)
    addSubview(titleLabel)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.imageTop),
      posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leading),
      posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.trailing),
      posterImageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
      posterImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
      
      titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Constants.labelTop),
      titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.leading),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: Constants.trailing),
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }
}
