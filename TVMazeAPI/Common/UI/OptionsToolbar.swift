//
//  OptionsToolbar.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import UIKit

protocol OptionsToolbarDelegate: AnyObject {
  func optionsToolbar(selectedButton index: Int, optionsToolbar: OptionsToolbar)
}

final class OptionsToolbar: UIView {
  private enum Constants {
    static let selectionViewHeightValue: CGFloat = 4
    static let cellWidthMultiplier: Int = 12
    static let cellHeight: CGFloat = 40
    static let padding: CGFloat = 8
    static let height: CGFloat = 44
    static let leading: CGFloat = 12
    static let trailing: CGFloat = -12
  }
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.registerCell(cellType: OptionsToolbarCollectionViewCell.self)
    view.backgroundColor = .white
    view.delegate = self
    view.dataSource = self
    view.showsHorizontalScrollIndicator = false
    view.showsVerticalScrollIndicator = false
    return view
  }()
  
  weak var delegate: OptionsToolbarDelegate?
  private var optionNames: [String]?
  
  private var fixedWidthMode: Bool = false {
    didSet {
      collectionView.bounces = !fixedWidthMode
      collectionView.isScrollEnabled = !fixedWidthMode
    }
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: UIScreen.main.bounds.size.width, height: Constants.height)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    buildView()
  }
  
  func setupToolbarLayout(optionNames: [String], fixedWidth: Bool = false) {
    self.optionNames = optionNames
    self.fixedWidthMode = fixedWidth
    collectionView.reloadData()
    selectFirstItem()
  }
  
  func selectFirstItem() {
    let indexPath = IndexPath(row: 0, section: 0)
    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
    self.collectionView(self.collectionView, didSelectItemAt: indexPath)
  }
}

extension OptionsToolbar: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return optionNames?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(indexPath: indexPath, type: OptionsToolbarCollectionViewCell.self)
    guard let option = optionNames?[indexPath.row] else {
      return UICollectionViewCell()
    }
    cell.setup(title: option)
    return cell
  }
}

extension OptionsToolbar: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.optionsToolbar(selectedButton: indexPath.row, optionsToolbar: self)
  }
}

extension OptionsToolbar: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if fixedWidthMode {
      let size = CGFloat(optionNames?.count ?? 1)
      let width = collectionView.frame.width/size - Constants.padding
      
      return CGSize(width: width, height: CGFloat(Constants.cellHeight))
    } else {
      let nameSize = optionNames?[indexPath.row].count ?? 0
      let cellWidth = nameSize * Constants.cellWidthMultiplier
      
      return CGSize(width: CGFloat(cellWidth), height: Constants.cellHeight)
    }
  }
}

extension OptionsToolbar: ViewCodable {
  
  func buildViewHierarchy() {
    addSubview(collectionView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leading),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.trailing),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
