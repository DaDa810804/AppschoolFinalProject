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
    
    weak var delegate: HalfViewControllerDelegate?
    var selectedIndexPath: IndexPath?
    var currencyData = ["所有幣種","BTC","USDT","LINK"]
    var imageData = ["red","btc","usdt","link"]
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
        if let selectedIndexPath = selectedIndexPath {
            switchCurrencyTableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
            switchCurrencyTableView.cellForRow(at: selectedIndexPath)?.accessoryType = .checkmark
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
        return currencyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = switchCurrencyTableView.dequeueReusableCell(withIdentifier: "SwitchCurrencyTableViewCell", for: indexPath) as? SwitchCurrencyTableViewCell
        cell?.setupUI()
        cell?.currencyLabel.text = "\(currencyData[indexPath.row])"
        cell?.iconImageView.image = UIImage(named: imageData[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath {
            let selectedCell = tableView.cellForRow(at: selectedIndexPath)
            selectedCell?.accessoryType = .none
        }
        //選中的字串
        let selectedCurrency = currencyData[indexPath.row]
        delegate?.didSelectCurrency(selectedCurrency)
        // 设置当前选中的单元格的勾号
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
        dismiss(animated: true)
        // 更新选中IndexPath
        
    }
}
