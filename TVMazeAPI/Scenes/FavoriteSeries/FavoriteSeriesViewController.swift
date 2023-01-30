//
//  FavoriteSeriesViewController.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import Combine
import UIKit

final class FavoriteSeriesViewController: UIViewController {
  private lazy var toolBar: OptionsToolbar = {
    let toolBar = OptionsToolbar()
    toolBar.setupToolbarLayout(optionNames: ["Id", "Alphabetically"])
    toolBar.delegate = self
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    return toolBar
  }()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.registerCell(cellType: FavoriteSeriesTableViewCell.self)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  
  private let viewModel: FavoriteSeriesViewModelable
  
  private var deletingIndex: Int?
  private var subscription: AnyCancellable?
  
  init(viewModel: FavoriteSeriesViewModelable) {
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
    tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), tag: 2)
    setupSubscribers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.fetchFavorite()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !viewModel.firstTimeScreenShown {
      viewModel.saveAlertShown()
      presentInitialAlert()
    }
  }
  
  private func setupSubscribers() {
    subscription = viewModel
      .updateUIPublisher
      .sink(receiveValue: { [weak self] in
      self?.tableView.reloadData()
    })
  }
  
  private func presentInitialAlert() {
    let alert = UIAlertController(title: "To unfavorite a series, just swipe left on it", message: "In its cell", preferredStyle: .alert)
    alert.addAction(.init(title: "Ok", style: .default))
    present(alert, animated: true)
  }
  
  private func presentDeleteConfirmation() {
    let alert = UIAlertController(title: "You sure you wanna unfavorite this?", message: "To select again just go to details page", preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] _ in
      if let index = self?.deletingIndex {
        self?.viewModel.removeFromFavorite(index: index)
      }
    })
    alert.addAction(confirmAction)
    alert.addAction(.init(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }
}

extension FavoriteSeriesViewController: OptionsToolbarDelegate {
  func optionsToolbar(selectedButton index: Int, optionsToolbar: OptionsToolbar) {
    viewModel.didSelectSortCriteria(index)
  }
}

extension FavoriteSeriesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.favoriteSeries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(indexPath: indexPath, type: FavoriteSeriesTableViewCell.self)
    let item = viewModel.favoriteSeries[indexPath.row]
    cell.updateContent(.init(imageURL: item.imageURL, title: item.title))
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deletingIndex = indexPath.row
      presentDeleteConfirmation()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectSeries(index: indexPath.row)
  }
}

extension FavoriteSeriesViewController: ViewCodable {
  func buildViewHierarchy() {
    view.addSubview(toolBar)
    view.addSubview(tableView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      toolBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    
      tableView.topAnchor.constraint(equalTo: toolBar.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
