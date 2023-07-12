//
//  HistoryViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/6.
//

import UIKit
import MJRefresh
import JGProgressHUD

class HistoryViewController: UIViewController {
    let myHud = JGProgressHUD()
    var userWalletAllCurrency: [String] = []
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
        backButton.setImage(UIImage(named: "downButton"), for: .normal)
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
    
    let emptyView = EmptyStateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myHud.textLabel.text = "Loading"
        setupUI()
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(TradeTableViewCell.self, forCellReuseIdentifier: "TradeTableViewCell")
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
        historyTableView.mj_header = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    
        if allCurrencyLabel.text == "全部幣別" {
            print("打100筆")
            fetchOrders()
        } else {
            fetchOrderForCurrency()
        }
    }
    
    func loadData() {
        if allCurrencyLabel.text == "全部幣別" {
            print("打100筆")
            ApiManager.shared.getOneHundredOrders { orders in
                if let orders = orders {
                    self.ordersData = orders
                    DispatchQueue.main.async {
                        self.historyTableView.reloadData()
                        self.historyTableView.mj_header?.endRefreshing()
                    }
                } else {
                    let alertController = UIAlertController(title: "網路不穩定", message: "是否繼續加載？", preferredStyle: .alert)
                    
                    let continueAction = UIAlertAction(title: "繼續", style: .default) { _ in
                        // 繼續執行其他操作
                        self.loadData() // 再次呼叫該方法繼續取得資料
                    }
                    alertController.addAction(continueAction)
                    
                    let cancelAction = UIAlertAction(title: "返回", style: .cancel) { _ in
                        // 返回上一頁或執行其他返回操作
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(cancelAction)
                    
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            guard let currency = allCurrencyLabel.text else { return }
            ApiManager.shared.getOrders(productId: "\(currency)-USD") { order, error in
                if let error = error {
                    //重新打
                    let alertController = UIAlertController(title: "網路不穩定", message: "是否繼續加載？", preferredStyle: .alert)
                    
                    let continueAction = UIAlertAction(title: "繼續", style: .default) { _ in
                        // 繼續執行其他操作
                        self.loadData() // 再次呼叫該方法繼續取得資料
                    }
                    alertController.addAction(continueAction)
                    
                    let cancelAction = UIAlertAction(title: "返回", style: .cancel) { _ in
                        // 返回上一頁或執行其他返回操作
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(cancelAction)

                    DispatchQueue.main.async {
                        self.emptyView.isHidden = false
                        self.historyTableView.mj_header?.endRefreshing()
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                if let order = order {
                    self.ordersData = order
                    if self.ordersData.isEmpty == true {
                        DispatchQueue.main.async {
                            self.emptyView.isHidden = false
                            self.historyTableView.mj_header?.endRefreshing()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.emptyView.isHidden = true
                            self.historyTableView.reloadData()
                            self.historyTableView.mj_header?.endRefreshing()
                        }
                    }
                }
            }
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        let indexPath = IndexPath(row: 0, section: 0)
        UserDefaults.standard.set(indexPath.row, forKey: "SelectedCurrencyIndexPath")
    }
    
    @objc func switchCurrencyTapped() {
        print("present出半個畫面的頁面")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hvc = storyboard.instantiateViewController(withIdentifier: "HalfViewController") as? HalfViewController
        if let sheetPresentationController = hvc!.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
        hvc?.userWalletAllCurrency = userWalletAllCurrency
        hvc!.delegate = self
        present(hvc!, animated: true)
    }
        
    func setupUI() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        view.addSubview(topLabel)
        view.addSubview(allCurrencyLabel)
        view.addSubview(switchCurrencyButton)
        view.addSubview(separatorView)
        view.addSubview(historyTableView)
        view.addSubview(emptyView)
        
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
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyView.topAnchor.constraint(equalTo: historyTableView.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: historyTableView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: historyTableView.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: historyTableView.bottomAnchor)
        ])
        emptyView.isHidden = true
    }
    
    func fetchOrderForCurrency() {
        myHud.show(in: view)
        guard let currency = allCurrencyLabel.text else { return }
        ApiManager.shared.getOrders(productId: "\(currency)-USD") { order,error in
            if let error = error {
                let alertController = UIAlertController(title: "網路不穩定", message: "是否繼續加載？", preferredStyle: .alert)
                
                let continueAction = UIAlertAction(title: "繼續", style: .default) { _ in
                    // 繼續執行其他操作
                    self.fetchOrderForCurrency() // 再次呼叫該方法繼續取得資料
                }
                alertController.addAction(continueAction)
                
                let cancelAction = UIAlertAction(title: "返回", style: .cancel) { _ in
                    // 返回上一頁或執行其他返回操作
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(cancelAction)
                
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                    self.myHud.dismiss()
                }
            }
            if let order = order {
                self.ordersData = order
                if self.ordersData.isEmpty == true {
                    DispatchQueue.main.async {
                        self.emptyView.isHidden = false
                        self.myHud.dismiss()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.emptyView.isHidden = true
                        self.historyTableView.reloadData()
                        self.myHud.dismiss()
                    }
                }
            }
        }
    }
    
    func fetchOrders() {
        myHud.show(in: view)
        ApiManager.shared.getOneHundredOrders { orders in
            if let orders = orders {
                self.ordersData = orders
                DispatchQueue.main.async {
                    self.historyTableView.reloadData()
                    self.myHud.dismiss()
                }
            } else {
                let alertController = UIAlertController(title: "網路不穩定", message: "是否繼續加載？", preferredStyle: .alert)
                
                let continueAction = UIAlertAction(title: "繼續", style: .default) { _ in
                    // 繼續執行其他操作
                    self.fetchOrders() // 再次呼叫該方法繼續取得資料
                }
                alertController.addAction(continueAction)
                
                let cancelAction = UIAlertAction(title: "返回", style: .cancel) { _ in
                    // 返回上一頁或執行其他返回操作
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(cancelAction)
                
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                    self.myHud.dismiss()
                }
            }
        }
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
        let side = order.side
        let modifiedString = order.productId.replacingOccurrences(of: "-USD", with: "")
        let middleLabel1Text = (side == "buy") ? "購入" : "賣出"
        let numberString = order.executedValue
        if let dotIndex = numberString.firstIndex(of: ".") {
            let endIndex = numberString.index(dotIndex, offsetBy: 9)
            let truncatedString = String(numberString[..<endIndex])
            cell?.setBottomLabel2Text("USD$ \(truncatedString)")
        }
        cell?.setTopLabelViewText("\(side)")
        cell?.setTopLabel2Text("\(timeChange(dateString: order.doneAt!))")
        cell?.setMiddleLabel1Text("\(middleLabel1Text) \(modifiedString)")
        cell?.setMiddleLabel2Text("\(order.size)")
        cell?.setBottomLabel1Text(order.status == "done" ? "成功" : order.status)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替换为您的故事板名称
        let stvc = storyboard.instantiateViewController(withIdentifier: "SuccessfulTransactionViewController") as? SuccessfulTransactionViewController
        stvc?.bottomButton.isHidden = true
        stvc?.orderData = ordersData[indexPath.row]
        navigationController?.pushViewController(stvc!, animated: true)
    }
    
}

extension HistoryViewController: HalfViewControllerDelegate {
    
    func didSelectCurrency(_ currency: String) {
        myHud.show(in: view)
        if currency == "所有幣種" {
            print("打100筆資料回來")
            ApiManager.shared.getOneHundredOrders { orders in
                if let orders = orders {
                    self.ordersData = orders
                    DispatchQueue.main.async {
                        self.emptyView.isHidden = true
                        self.allCurrencyLabel.text = "全部幣別"
                        self.historyTableView.reloadData()
                        self.myHud.dismiss()
                    }
                } else {
                    let alertController = UIAlertController(title: "網路不穩定", message: "是否繼續加載？", preferredStyle: .alert)
                    
                    let continueAction = UIAlertAction(title: "繼續", style: .default) { _ in
                        // 繼續執行其他操作
                        self.fetchOrders() // 再次呼叫該方法繼續取得資料
                    }
                    alertController.addAction(continueAction)
                    
                    let cancelAction = UIAlertAction(title: "返回", style: .cancel) { _ in
                        // 返回上一頁或執行其他返回操作
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(cancelAction)
                    
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                        self.myHud.dismiss()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.allCurrencyLabel.text = currency
                ApiManager.shared.getOrders(productId: "\(currency)-USD") { order,error in
                    if let error = error {
                        print("errorerror\(error)")
                        //回傳錯誤，表示要重新打一次
                        let alertController = UIAlertController(title: "網路不穩定", message: "是否繼續加載？", preferredStyle: .alert)
                        
                        let continueAction = UIAlertAction(title: "繼續", style: .default) { _ in
                            // 繼續執行其他操作
                            self.fetchOrderForCurrency() // 再次呼叫該方法繼續取得資料
                        }
                        alertController.addAction(continueAction)
                        
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                            // 返回上一頁或執行其他返回操作
                            DispatchQueue.main.async {
                                self.emptyView.isHidden = false
                            }
                        }
                        alertController.addAction(cancelAction)
                        
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                            self.myHud.dismiss()
                        }
                    }
                    if let order = order {
                        self.ordersData = order
                        if self.ordersData.isEmpty == true {
                            DispatchQueue.main.async {
                                self.emptyView.isHidden = false
                                self.myHud.dismiss()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.emptyView.isHidden = true
                                self.myHud.dismiss()
                                self.historyTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
