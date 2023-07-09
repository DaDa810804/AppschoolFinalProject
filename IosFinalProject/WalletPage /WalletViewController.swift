//
//  WalletViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/6.
//

import UIKit
import MJRefresh

class WalletViewController: UIViewController {
    
    var inputNumber: Int? = 0
    var userWalletAllCurrency: [String] = []
    var balanceArray: [Double] = []
    let redView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .myRed
        return view
    }()
    
    let walletLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "錢包"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    let historydButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushHistoryTapped), for: .touchUpInside)
        button.setTitle("歷史紀錄", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "總餘額"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    let balanceHiddenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(eyesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let showBalanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NT$ 35867"
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "幣別"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "數量/總額"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private var walletTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletTableView.dataSource = self
        walletTableView.delegate = self
        walletTableView.register(WalletTableViewCell.self, forCellReuseIdentifier: "WalletTableViewCell")
        setupUI()
        let refreshControl = MJRefreshNormalHeader()
        refreshControl.setTitle("下拉刷新", for: .idle)
        refreshControl.setTitle("釋放更新", for: .pulling)
        refreshControl.setTitle("正在刷新...", for: .refreshing)

        // 設置下拉刷新的回調方法
        refreshControl.refreshingBlock = { [weak self] in
            // 在這裡執行下拉刷新時的操作
            // 例如重新加載數據、獲取最新數據等
            // 完成後，使用 refreshControl.endRefreshing() 結束刷新
            self?.loadData()
        }

        // 設置下拉刷新控制項
        walletTableView.mj_header = refreshControl
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        ApiManager.shared.getAccounts { accounts in
            self.userWalletAllCurrency = self.getCurrencies(accounts: accounts)
            guard let balance = self.getBalance(accounts: accounts) else { return }
            getExchangeRate() { (exchangeRate) in
                if let exchangeRate = exchangeRate {
                    let twdAmount = (Double(balance) ?? 0.0) * exchangeRate
                    DispatchQueue.main.async {
                        self.showBalanceLabel.text = "NT$ \(Int(twdAmount))"
                        self.inputNumber = Int(twdAmount)
                        self.walletTableView.reloadData()
                    }
                    print("\(balance) USD = \(twdAmount) TWD")
                } else {
                    print("無法獲取匯率資料")
                }
            }
        }
    }
    
    func loadData() {
        ApiManager.shared.getAccounts { accounts in
            self.userWalletAllCurrency = self.getCurrencies(accounts: accounts)
            guard let balance = self.getBalance(accounts: accounts) else { return }
            getExchangeRate() { (exchangeRate) in
                if let exchangeRate = exchangeRate {
                    let twdAmount = (Double(balance) ?? 0.0) * exchangeRate
                    DispatchQueue.main.async {
                        self.showBalanceLabel.text = "NT$ \(Int(twdAmount))"
                        self.inputNumber = Int(twdAmount)
                        self.walletTableView.reloadData()
                        self.walletTableView.mj_header?.endRefreshing()
                    }
                    print("\(balance) USD = \(twdAmount) TWD")
                } else {
                    print("無法獲取匯率資料")
                }
            }
        }
    }
    
    func getCurrencies(accounts: [Account]) -> [String] {
        var currencies: [String] = []
        for account in accounts {
            currencies.append(account.currency)
        }
        return currencies
    }
    
    func getBalance(accounts: [Account]) -> String? {
        var totalBalance = 0.0
        for account in accounts {
            totalBalance += Double(account.balance)!
            balanceArray.append(Double(account.balance)!)
        }
        let formattedBalance = String(format: "%.2f", totalBalance)
        return formattedBalance
    }
    
    func setupUI() {
        view.addSubview(redView)
        view.addSubview(walletLabel)
        view.addSubview(historydButton)
        view.addSubview(balanceLabel)
        view.addSubview(balanceHiddenButton)
        view.addSubview(showBalanceLabel)
        view.addSubview(currencyLabel)
        view.addSubview(quantityLabel)
        view.addSubview(walletTableView)
        view.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            walletLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            walletLabel.leadingAnchor.constraint(equalTo: redView.leadingAnchor, constant: 16),
            
            historydButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            historydButton.trailingAnchor.constraint(equalTo: redView.trailingAnchor, constant: -16),
            
            balanceLabel.topAnchor.constraint(equalTo: walletLabel.bottomAnchor, constant: 32),
            balanceLabel.leadingAnchor.constraint(equalTo: redView.leadingAnchor, constant: 16),
            
            balanceHiddenButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor),
            balanceHiddenButton.leadingAnchor.constraint(equalTo: balanceLabel.trailingAnchor, constant: 8),
            
            showBalanceLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 8),
            showBalanceLabel.leadingAnchor.constraint(equalTo: redView.leadingAnchor, constant: 16),
            showBalanceLabel.bottomAnchor.constraint(equalTo: redView.bottomAnchor,constant: -16),
            
            currencyLabel.topAnchor.constraint(equalTo: redView.bottomAnchor, constant: 16),
            currencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            quantityLabel.topAnchor.constraint(equalTo: redView.bottomAnchor, constant: 16),
            quantityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 15),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            walletTableView.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 16),
            walletTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            walletTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            walletTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func pushHistoryTapped() {
        //去資產紀錄
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替换为您的故事板名称
        let hvc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController
        //把錢包的所有幣別傳過去
        hvc?.userWalletAllCurrency = userWalletAllCurrency
        navigationController?.pushViewController(hvc!, animated: true)
    }
    
    @objc func eyesButtonTapped() {
        if showBalanceLabel.text == "NT$ ******" {
            showBalanceLabel.text = "NT$ \(inputNumber!)"
        } else {
            showBalanceLabel.text = "NT$ ******"
        }
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userWalletAllCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = walletTableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as? WalletTableViewCell
        cell?.setupUI()
        DispatchQueue.main.async {
            cell?.configure(with: self.userWalletAllCurrency[indexPath.row])
            cell?.currencyLabel.text = self.userWalletAllCurrency[indexPath.row]
            cell?.quantityLabel.text = String(format: "%.2f", self.balanceArray[indexPath.row])
            getExchangeRate() { (exchangeRate) in
                if let exchangeRate = exchangeRate {
                    let twdAmount = self.balanceArray[indexPath.row] * exchangeRate
                    DispatchQueue.main.async {
                        cell?.balanceLabel.text = "\(Int(twdAmount))"
                    }
                } else {
                    print("無法獲取匯率資料")
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


