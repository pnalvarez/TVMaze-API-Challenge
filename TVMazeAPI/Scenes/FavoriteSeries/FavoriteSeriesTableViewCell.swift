//
//  FavoriteSeriesTableViewCell.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import UIKit

final class FavoriteSeriesTableViewCell: UITableViewCell {
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
  private lazy var posterImageView: UIImageView = {
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
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    buildView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateContent(_ viewModel: ViewModel) {
    posterImageView.sd_setImage(with: viewModel.imageURL)
    titleLabel.text = viewModel.title
  }
}

extension FavoriteSeriesTableViewCell: ViewCodable {
  func buildViewHierarchy() {
    addSubview(posterImageView)
    addSubview(titleLabel)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.imageLeading),
      posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.imageTop),
      posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.imageBottom),
      posterImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
      posterImageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
      titleLabel.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Constants.labelLeading),
    ])
  }
}
