//
//  SeriesDetailsViewController.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import UIKit
import Combine

final class SeriesDetailsViewController: UIViewController {
  private enum Constants {
    static let imageTop: CGFloat = 16
    static let nameLabelTop: CGFloat = 32
    static let labelLeading: CGFloat = 16
    static let labelTrailing: CGFloat = -16
    static let seasonsTop: CGFloat = 32
    static let stackSpacing: CGFloat = 16
    static let labelSpacing: CGFloat = 8
    static let buttonHeight: CGFloat = 64
    static let buttonWidth: CGFloat = 120
    static let buttonTop: CGFloat = 32
  }
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
    stack.spacing = Constants.stackSpacing
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
  
  private lazy var errorView: GenericErrorView = {
    let view = GenericErrorView()
    view.isHidden = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var favoriteButton: UIButton =  {
    let button = UIButton()
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.backgroundColor = ColorPalette.primaryBlue
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    return button
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
    viewModel
      .errorPublisher
      .sink(receiveValue: { [weak self] in
        self?.errorView.isHidden = false
        self?.errorView.setErrorText($0)
    })
      .store(in: &subscriptions)
    viewModel
      .isFavoritePublisher
      .sink(receiveValue: { [weak self] in
        guard let self else { return }
        self.favoriteButton.setTitle(self.viewModel.buttonTitle, for: .normal)
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
  
  @objc private func didTapFavorite() {
    viewModel.didTapFavoriteButton()
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
    view.addSubview(errorView)
    scrollView.addSubview(contentView)
    contentView.addSubview(posterImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(summaryLabel)
    contentView.addSubview(scheduleLabel)
    contentView.addSubview(genresLabel)
    contentView.addSubview(favoriteButton)
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

      posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.imageTop),
      posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Constants.nameLabelTop),
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelLeading),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.labelTrailing),

      summaryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.labelSpacing),
      summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelLeading),
      summaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.labelTrailing),

      genresLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: Constants.labelSpacing),
      genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelLeading),
      genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.labelTrailing),

      scheduleLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: Constants.labelSpacing),
      scheduleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelLeading),
      scheduleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.labelTrailing),
      
      favoriteButton.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: Constants.buttonTop),
      favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      favoriteButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
      favoriteButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),

      seasonStackView.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: Constants.seasonsTop),
      seasonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      seasonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      seasonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
