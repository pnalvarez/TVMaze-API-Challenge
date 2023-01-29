//
//  SeriesListViewController.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 27/01/23.
//

import UIKit
import Combine

final class SeriesListViewController: UIViewController {
  // MARK: - UI Properties
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.bounces = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.registerCell(cellType: SeriesListTableViewCell.self)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.prefetchDataSource = self
    return tableView
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
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let viewModel: SeriesListViewModelable
  private var subscriptions: Set<AnyCancellable> = .init()
  
  init(viewModel: SeriesListViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    buildView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet"), tag: 0)
    setupSubscribers()
    viewModel.viewDidLoad()
  }
}

private extension SeriesListViewController {
  func setupSubscribers() {
    viewModel
      .loadingPublisher
      .sink(receiveValue: { [weak self] in $0 ? self?.displayLoading() : self?.stopLoading() })
      .store(in: &subscriptions)
    viewModel
      .updateUIPublisher
      .sink(receiveValue: { [weak self] in
      self?.tableView.reloadData()
    })
    .store(in: &subscriptions)
    viewModel
      .showErrorPublisher
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
  
  func stopLoading() {
    loadingView.stopAnimating()
  }
}

extension SeriesListViewController: ViewCodable {
  func buildViewHierarchy() {
    view.addSubview(tableView)
    view.addSubview(loadingView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

extension SeriesListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.seriesItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = viewModel.seriesItems[indexPath.row]
    let cell = tableView.dequeueReusableCell(indexPath: indexPath, type: SeriesListTableViewCell.self)
    cell.updateContent(imageURL: item.imageURL, title: item.title)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didClickCell(indexPath.row)
  }
}

extension SeriesListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    viewModel.willDisplayCells(indexPaths.map { $0.row })
  }
}


