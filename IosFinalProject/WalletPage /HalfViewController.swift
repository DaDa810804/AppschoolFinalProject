//
//  HalfViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/6.
//

import UIKit

protocol HalfViewControllerDelegate: AnyObject {
    func didSelectCurrency(_ currency: String)
}

class HalfViewController: UIViewController {
    
    var userWalletAllCurrency: [String] = []
    weak var delegate: HalfViewControllerDelegate?
    var selectedIndexPath: IndexPath?

    let backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return backButton
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "選擇幣種"
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var switchCurrencyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        switchCurrencyTableView.dataSource = self
        switchCurrencyTableView.delegate = self
        switchCurrencyTableView.register(SwitchCurrencyTableViewCell.self, forCellReuseIdentifier: "SwitchCurrencyTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userWalletAllCurrency.insert("所有幣種", at: 0)
        if let savedIndexPathRow = UserDefaults.standard.value(forKey: "SelectedCurrencyIndexPath") as? Int {
            selectedIndexPath = IndexPath(row: savedIndexPathRow, section: 0)
        }
    }
    func setupUI() {
        view.addSubview(backButton)
        view.addSubview(topLabel)
        view.addSubview(switchCurrencyTableView)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            switchCurrencyTableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            switchCurrencyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            switchCurrencyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            switchCurrencyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension HalfViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userWalletAllCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = switchCurrencyTableView.dequeueReusableCell(withIdentifier: "SwitchCurrencyTableViewCell", for: indexPath) as? SwitchCurrencyTableViewCell
        cell?.setupUI()
        cell?.currencyLabel.text = "\(userWalletAllCurrency[indexPath.row])"
        cell?.configure(with: userWalletAllCurrency[indexPath.row])
        if indexPath == selectedIndexPath {
            cell?.accessoryType = .checkmark
            cell?.tintColor = UIColor.black
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選中的字串
        let selectedCurrency = userWalletAllCurrency[indexPath.row]
        delegate?.didSelectCurrency(selectedCurrency)
        UserDefaults.standard.set(indexPath.row, forKey: "SelectedCurrencyIndexPath")
        dismiss(animated: true)
    }
}
