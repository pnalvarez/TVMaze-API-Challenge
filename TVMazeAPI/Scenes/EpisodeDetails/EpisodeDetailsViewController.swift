//
//  EpisodeDetailsViewController.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import UIKit

final class EpisodeDetailsViewController: UIViewController {
  private enum Constants {
    static let imageTop: CGFloat = 32
    static let leading: CGFloat = 16
    static let trailing: CGFloat = -16
    static let labelSpacing: CGFloat = 8
    static let imageBotton: CGFloat = 16
  }
  private lazy var posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 8
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var numberLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var seasonLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var summaryLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let viewModel: EpisodeDetailsViewModelable
  
  init(viewModel: EpisodeDetailsViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    buildView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    fillContent()
  }
  
  private func fillContent() {
    posterImageView.sd_setImage(with: viewModel.episodeDisplayModel.image)
    nameLabel.text = viewModel.episodeDisplayModel.name
    summaryLabel.text = viewModel.episodeDisplayModel.summary
    seasonLabel.text = viewModel.episodeDisplayModel.season
    numberLabel.text = viewModel.episodeDisplayModel.number
  }
}

extension EpisodeDetailsViewController: ViewCodable {
  func buildViewHierarchy() {
    view.addSubview(posterImageView)
    view.addSubview(nameLabel)
    view.addSubview(summaryLabel)
    view.addSubview(seasonLabel)
    view.addSubview(numberLabel)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.imageTop),
      posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Constants.imageBotton),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leading),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: Constants.trailing),
      
      summaryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.imageBotton),
      summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leading),
      summaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: Constants.trailing),
      
      seasonLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: Constants.imageBotton),
      seasonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leading),
      seasonLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: Constants.trailing),
      
      numberLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor, constant: Constants.imageBotton),
      numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leading),
      numberLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: Constants.trailing),
    ])
  }
}
