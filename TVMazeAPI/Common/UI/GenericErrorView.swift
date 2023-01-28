//
//  GenericErrorView.swift
//  TVMazeAPI
//
//  Created by Pedro Alvarez on 28/01/23.
//

import UIKit

final class GenericErrorView: UIView {
  // MARK: - Constants
  private enum Constants {
    static let title = "An error occurred"
    static let stackSpacing: CGFloat = 16
  }
  
  // MARK: - UI properties
  private lazy var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "error-icon")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 20, weight: .bold)
    label.text = Constants.title
    label.textAlignment = .center
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = Constants.stackSpacing
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    buildView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setErrorText(_ text: String) {
    descriptionLabel.text = text
  }
}

extension GenericErrorView: ViewCodable {
  func buildViewHierarchy() {
    addSubview(stackView)
    stackView.addArrangedSubview(iconImageView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(descriptionLabel)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }
}
