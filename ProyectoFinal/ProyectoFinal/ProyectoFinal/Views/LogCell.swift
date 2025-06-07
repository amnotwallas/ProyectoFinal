//
//  LogCell.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 04/06/25.
//

import UIKit

class LogCardCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let userLabel = UILabel()
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    private let containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        applyShadow()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        applyShadow()
    }

    func configure(tipo: String, producto: String, usuario: String, descripcion: String, fecha: String) {
        titleLabel.text = "\(tipo.capitalized) - \(producto)"
        userLabel.text = "👤 Usuario: \(usuario)"
        descriptionLabel.text = descripcion
        dateLabel.text = "📅 \(fecha)"
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        userLabel.font = .systemFont(ofSize: 14)
        userLabel.textColor = .secondaryLabel

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 0

        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .systemGray

        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(userLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(dateLabel)

        containerView.addSubview(stackView)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }

    private func applyShadow() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerView.layer.shadowRadius = 5
        containerView.layer.masksToBounds = false
    }
}
