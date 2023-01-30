//
//  OptionsToolbarCollectionViewCell.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 29/01/23.
//

import UIKit

final class OptionsToolbarCollectionViewCell: UICollectionViewCell {
  private enum Constants {
    static let height: CGFloat = 4
  }
  
  var title: String = "" {
    didSet {
      titleLbl.text = title
    }
  }
  
  override var isSelected: Bool {
    didSet {
      titleLbl.textColor = isSelected ? ColorPalette.primaryBlue : .black
      selectionView.backgroundColor = isSelected ? ColorPalette.primaryBlue : .white
    }
  }
  
  private lazy var titleLbl: UILabel = {
    let view = UILabel()
    view.font = .systemFont(ofSize: 16)
    view.textAlignment = .center
    view.translatesAutoresizingMaskIntoConstraints = false
    view.numberOfLines = 0
    return view
  }()
  
  private lazy var selectionView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    buildView()
  }
  
  func setup(title: String) {
    self.title = title
    buildView()
  }
}

extension OptionsToolbarCollectionViewCell: ViewCodable {
  
  func buildViewHierarchy() {
    addSubview(titleLbl)
    addSubview(selectionView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      titleLbl.topAnchor.constraint(equalTo: topAnchor),
      titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLbl.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      selectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      selectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      selectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      selectionView.heightAnchor.constraint(equalToConstant: Constants.height)
    ])
  }
}
