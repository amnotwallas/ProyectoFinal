//
//  ProductCardCell.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import UIKit

class ProductCardCell: UICollectionViewCell {

    private let nameLabel = UILabel()
    private let cantidadLabel = UILabel()
    private let priceLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        applyShadow()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        applyShadow()
    }

    func configure(with product: Product) {
        nameLabel.text = product.nombre
        cantidadLabel.text = "Cantidad: \(product.cantidad)"
        priceLabel.text = "$\(product.precio)"
    }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = false

        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .label

        cantidadLabel.font = .systemFont(ofSize: 14)
        cantidadLabel.textColor = .secondaryLabel
        cantidadLabel.numberOfLines = 1

        priceLabel.font = .systemFont(ofSize: 16, weight: .medium)
        priceLabel.textColor = .systemGreen

        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(cantidadLabel)
        stackView.addArrangedSubview(priceLabel)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func applyShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false
        backgroundColor = .clear
    }
}
