//
//  HistoryViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/6.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var ordersData: [Order] = []
    let backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return backButton
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "資產紀錄"
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let allCurrencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "全部幣別"
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let switchCurrencyButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(switchCurrencyTapped), for: .touchUpInside)
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return backButton
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private var historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(TradeTableViewCell.self, forCellReuseIdentifier: "TradeTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        ApiManager.shared.getOneHundredOrders { orders in
            guard let orders = orders else { return }
            self.ordersData = orders
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchCurrencyTapped() {
        print("present出半個畫面的頁面")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hvc = storyboard.instantiateViewController(withIdentifier: "HalfViewController") as? HalfViewController
        if let sheetPresentationController = hvc!.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
        hvc!.delegate = self
        present(hvc!, animated: true)
    }
    
    func setupUI() {
        view.addSubview(backButton)
        view.addSubview(topLabel)
        view.addSubview(allCurrencyLabel)
        view.addSubview(switchCurrencyButton)
        view.addSubview(separatorView)
        view.addSubview(historyTableView)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            topLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            allCurrencyLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 32),
            allCurrencyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            switchCurrencyButton.centerYAnchor.constraint(equalTo: allCurrencyLabel.centerYAnchor),
            switchCurrencyButton.leadingAnchor.constraint(equalTo: allCurrencyLabel.trailingAnchor, constant: 16),
            
            separatorView.topAnchor.constraint(equalTo: allCurrencyLabel.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            historyTableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "TradeTableViewCell", for: indexPath) as? TradeTableViewCell
        let order = ordersData[indexPath.row]
        cell?.setupUI()
        cell?.setTopLabelViewText(order.side)
        cell?.setTopLabel2Text("\(timeChange(dateString: order.doneAt))")
        let originalString = order.productID
        let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
        
        cell?.setMiddleLabel1Text("\(order.side) \(modifiedString)")
        cell?.setMiddleLabel2Text("\(order.size)")
        cell?.setBottomLabel1Text("\(order.status)")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替换为您的故事板名称
        let stvc = storyboard.instantiateViewController(withIdentifier: "SuccessfulTransactionViewController") as? SuccessfulTransactionViewController
        stvc?.bottomButton.isHidden = true
        navigationController?.pushViewController(stvc!, animated: true)
    }
    
}

extension HistoryViewController: HalfViewControllerDelegate {
    
    func didSelectCurrency(_ currency: String) {
        if currency == "所有幣種" {
            print("打100筆資料回來")
            ApiManager.shared.getOneHundredOrders { orders in
                guard let orders = orders else { return }
                self.ordersData = orders
                DispatchQueue.main.async {
                    self.allCurrencyLabel.text = "全部幣別"
                    self.historyTableView.reloadData()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.allCurrencyLabel.text = currency
                ApiManager.shared.getOrders(productId: "\(currency)-USD") { order in
                    self.ordersData = order!
                    DispatchQueue.main.async {
                        self.historyTableView.reloadData()
                    }
                }
            }
        }
    }
}
