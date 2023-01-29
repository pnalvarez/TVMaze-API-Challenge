//
//  SeriesDetailsViewController.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import UIKit
import Combine

final class SeriesDetailsViewController: UIViewController {
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.bounces = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
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
  
  private lazy var scheduleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var genresLabel: UILabel = {
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
  
  private lazy var seasonStackView: UIStackView = {
    let stack = UIStackView()
    stack.spacing = 16
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private lazy var loadingView: LoadingView = {
    let view = LoadingView()
    view.hidesWhenStopped = true
    view.isHidden = false
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let viewModel: SeriesDetailsViewModelable
  
  private var subscriptions: Set<AnyCancellable> = .init()
  
  init(viewModel: SeriesDetailsViewModelable) {
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
    setupSubscribers()
    viewModel.viewDidLoad()
  }
  
  private func setupSubscribers() {
    viewModel
      .loadingPublisher
      .sink(receiveValue: { [weak self] in
        $0 ? self?.enableLoading() : self?.disableLoading()
      })
      .store(in: &subscriptions)
    viewModel
      .dataPublisher
      .sink(receiveValue: { [weak self] in
        self?.updateUI($0)
    })
      .store(in: &subscriptions)
  }
  
  private func enableLoading() {
    loadingView.startAnimating()
    loadingView.isHidden = false
  }
  
  private func disableLoading() {
    loadingView.stopAnimating()
  }
  
  private func updateUI(_ model: SeriesDetailsDisplayModel) {
    posterImageView.sd_setImage(with: model.image)
    nameLabel.text = model.name
    genresLabel.text = model.genres
    summaryLabel.text = model.summary
    scheduleLabel.text = model.schedule
    seasonStackView.subviews.forEach {
      $0.removeFromSuperview()
    }
    for i in (0..<model.seasons.episodes.count) {
      let seasonView = SeriesSeasonView(frame: .zero, seasonNumber: i)
      seasonView.setContent("Season \(i)", model.seasons.episodes[i])
      seasonView.delegate = self
      seasonStackView.addArrangedSubview(seasonView)
    }
  }
}

extension SeriesDetailsViewController: SeriesSeasonViewDelegate {
  func didSelectEpisode(_ season: Int, episode: Int) {
    viewModel.didClickEpisode(season, episode)
  }
}

extension SeriesDetailsViewController: ViewCodable {
  func buildViewHierarchy() {
    view.addSubview(scrollView)
    view.addSubview(loadingView)
    scrollView.addSubview(contentView)
    contentView.addSubview(posterImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(summaryLabel)
    contentView.addSubview(scheduleLabel)
    contentView.addSubview(genresLabel)
    contentView.addSubview(seasonStackView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 32),
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

      summaryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
      summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      summaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

      genresLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 4),
      genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

      scheduleLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 4),
      scheduleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      scheduleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

      seasonStackView.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 32),
      seasonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      seasonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      seasonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
