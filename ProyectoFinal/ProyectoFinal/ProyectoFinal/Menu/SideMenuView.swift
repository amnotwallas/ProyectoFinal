//
//  SideMenuView.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import UIKit

class SideMenuView: UIView, UITableViewDelegate, UITableViewDataSource {

    var didSelectOption: ((MenuOption) -> Void)?

    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTableView()
        applyShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func applyShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 4, height: 0)
        layer.shadowRadius = 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOption.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = MenuOption.allCases[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "\(option.icon) \(option.title)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textColor = .label
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = MenuOption.allCases[indexPath.row]
        didSelectOption?(option)
    }
}
