//
//  SeriesSeasonView.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import UIKit

protocol SeriesSeasonViewDelegate: AnyObject {
  func didSelectEpisode(_ season: Int, episode: Int)
}

final class SeriesSeasonView: UIView {
  private enum Constants {
    static let titleTop: CGFloat = 8
    static let collectionViewTop: CGFloat = 16
    static let titleLeading: CGFloat = 16
    static let collectionViewBottom: CGFloat = 8
  }
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    let layout = UICollectionViewLayout()
    flowLayout.itemSize = CGSize(width: 20, height: 20)
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumInteritemSpacing = 0.0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.collectionViewLayout = flowLayout
    collectionView.bounces = false
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    collectionView.registerCell(cellType: SeriesDetailsEpisodeCollectionViewCell.self)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  weak var delegate: SeriesSeasonViewDelegate?
  
  private var seasonNumber: Int = 0
  
  private var episodes: [EpisodeModel] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  
  init(frame: CGRect, seasonNumber: Int) {
    self.seasonNumber = seasonNumber
    super.init(frame: frame)
    buildView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setContent(_ title: String, _ episodes: [EpisodeModel]) {
    titleLabel.text = title
    self.episodes = episodes
  }
}

extension SeriesSeasonView: ViewCodable {
  func buildViewHierarchy() {
    addSubview(titleLabel)
    addSubview(collectionView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleTop),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLeading),
      
      collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.collectionViewTop),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.heightAnchor.constraint(equalToConstant: 200),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

extension SeriesSeasonView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: (collectionView.frame.size.width - 10) / 2, height: (collectionView.frame.size.width - 10) / 2)
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.init(top: 0, left: 26, bottom: 0, right: 26)
  }
}

extension SeriesSeasonView: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    episodes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(indexPath: indexPath, type: SeriesDetailsEpisodeCollectionViewCell.self)
    cell.setContent(URL(string: episodes[indexPath.item].image.medium), episodes[indexPath.row].name)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectEpisode(seasonNumber, episode: indexPath.row)
  }
}
