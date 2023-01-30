//
//  SeriesSearchViewController.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import UIKit
import Combine

final class SeriesSearchViewController: UIViewController {
  private enum Constants {
    static let textFieldTop: CGFloat = 32
    static let textFieldTrailing: CGFloat = -16
    static let textFieldLeading: CGFloat = 16
    static let searchButtonTrailing: CGFloat = -16
    static let searchButtonWidth: CGFloat = 80
    static let detailsTop: CGFloat = 64
    static let detailsLeading: CGFloat = 16
    static let detailsTrailing: CGFloat = -16
    static let loadingTop: CGFloat = 24
  }
  
  private lazy var textField: UITextField = {
    let textField = UITextField()
    textField.layer.cornerRadius = 8
    textField.layer.borderWidth = 1
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.addTarget(self, action: #selector(searchQueryDidChange), for: .editingChanged)
    return textField
  }()
  
  private lazy var searchButton: UIButton = {
    let button = UIButton()
    button.isEnabled = false
    button.setTitle("Search", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.backgroundColor = ColorPalette.blueDisabled
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
    return button
  }()
  
  private lazy var loadingView: LoadingView = {
    let view = LoadingView()
    view.hidesWhenStopped = true
    view.isHidden = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var detailsView: ImageNameVerticalView = {
    let view = ImageNameVerticalView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
    return view
  }()
  
  private lazy var errorView: GenericErrorView = {
    let view = GenericErrorView()
    view.isHidden = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let viewModel: SeriesSearchViewModelable
  
  private var subscriptions: Set<AnyCancellable> = .init()
  
  init(viewModel: SeriesSearchViewModelable) {
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
    tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    setupSubscribers()
  }
}

private extension SeriesSearchViewController {
  @objc func didTapSearch() {
    detailsView.isHidden = true
    errorView.isHidden = true
    viewModel.didTapSearch(textField.text ?? "")
  }
  
  @objc func searchQueryDidChange() {
    viewModel.didChangeTextField(textField.text ?? "")
  }
  
  func setupSubscribers() {
    viewModel
      .loadingPublisher
      .sink(receiveValue: { [weak self] in
        $0 ? self?.displayLoading() : self?.removeLoading()
    })
      .store(in: &subscriptions)
    viewModel
      .seriesItemPublisher
      .sink(receiveValue: { [weak self] in
        self?.detailsView.isHidden = false
        self?.detailsView.setContent($0)
      })
      .store(in: &subscriptions)
    viewModel
      .buttonEnabledPublisher
      .sink(receiveValue: { [weak self] in
        self?.setSearchButtonEnabled($0)
    })
      .store(in: &subscriptions)
    viewModel
      .errorPublisher
      .sink(receiveValue: { [weak self] in
        self?.errorView.isHidden = false
        self?.errorView.setErrorText($0)
    })
      .store(in: &subscriptions)
  }
  
  func displayLoading() {
    loadingView.startAnimating()
    loadingView.isHidden = false
  }
  
  func removeLoading() {
    loadingView.stopAnimating()
  }
  
  func setSearchButtonEnabled(_ enabled: Bool) {
    searchButton.isEnabled = enabled
    searchButton.backgroundColor = enabled ? ColorPalette.primaryBlue : ColorPalette.blueDisabled
  }
}

extension SeriesSearchViewController: ViewCodable {
  func buildViewHierarchy() {
    view.addSubview(textField)
    view.addSubview(searchButton)
    view.addSubview(detailsView)
    view.addSubview(loadingView)
    view.addSubview(errorView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.textFieldTop),
      textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.textFieldLeading),
      textField.heightAnchor.constraint(equalTo: searchButton.heightAnchor),
      textField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: Constants.searchButtonTrailing),
      
      searchButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
      searchButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
      searchButton.widthAnchor.constraint(equalToConstant: Constants.searchButtonWidth),
      searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.searchButtonTrailing),
      
      detailsView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.detailsTop),
      detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.detailsLeading),
      detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.detailsTrailing),
      
      loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      errorView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 64),
      errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
