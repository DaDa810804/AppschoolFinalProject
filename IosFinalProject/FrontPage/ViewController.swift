//
//  ViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/28.
//

import UIKit
import Starscream
import MJRefresh

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    var isOverlayViewAdded = false
    var producArray: [String] = []
    var userWalletAllCurrency: [String] = []
    var inputNumber: Int? = 0
    let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "總餘額"
        return label
    }()
    
    let moneyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24,weight: .medium)
//        label.text = "NT$ \(inputNumber!)"
        return label
    }()
    
    let eyesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(eyesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        moneyLabel.text = "NT$\(inputNumber!)"
        myTableView.contentInsetAdjustmentBehavior = .never
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
        myTableView.mj_header = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        ApiManager.shared.getProducts { products in
            self.producArray = products
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }

        ApiManager.shared.getAccounts { accounts in
            self.userWalletAllCurrency = self.getCurrencies(accounts: accounts)
            self.getBalance(accounts: accounts) { balance in
                if let number = Double(balance) {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    let integerValue = Int64(number)
                    if let formattedNumber = formatter.string(from: NSNumber(value: integerValue)) {
                        print(formattedNumber) // 印出 29,345,127,312.234
                        DispatchQueue.main.async {
                            self.moneyLabel.text = "NT$ \(formattedNumber)"
                            self.inputNumber = Int(integerValue)
                        }
                    } else {
                        print("Invalid number string")
                    }
                } else {
                    print("無法將字串轉換為數字")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addOverlayView()
    }
    
    func loadData() {
        ApiManager.shared.getProducts { products in
            self.producArray = products
            DispatchQueue.main.async {
                self.myTableView.reloadData()
//                self.myTableView.mj_header?.endRefreshing() // 結束刷新
            }
        }

        ApiManager.shared.getAccounts { accounts in
            self.userWalletAllCurrency = self.getCurrencies(accounts: accounts)
            self.getBalance(accounts: accounts) { balance in
                if let number = Double(balance) {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    let integerValue = Int64(number)
                    if let formattedNumber = formatter.string(from: NSNumber(value: integerValue)) {
                        print(formattedNumber) // 印出 29,345,127,312.234
                        DispatchQueue.main.async {
                            self.moneyLabel.text = "NT$ \(formattedNumber)"
                            self.inputNumber = Int(integerValue)
                            self.myTableView.mj_header?.endRefreshing()
                        }
                    } else {
                        print("Invalid number string")
                    }
                } else {
                    print("無法將字串轉換為數字")
                }
            }
        }
    }

    func getUSDBalance(accounts: [Account]) -> String? {
        for account in accounts {
            if account.currency == "USD" {
                return account.balance
            }
        }
        return nil
    }
    
    func getBalance(accounts: [Account], completion: @escaping (String) -> Void) {
        let queue = DispatchQueue(label: "balanceQueue")
        let group = DispatchGroup()
        var ntBalance = 0.0
        
        for account in accounts {
            group.enter()
            queue.async {
                getExchangeRateToCurrency(currency: account.currency) { (exchangeRate) in
                    if let exchangeRate = exchangeRate {
                        let twdAmount = (Double(account.balance) ?? 0.0) * exchangeRate
                        ntBalance += twdAmount
                        print("多少\(twdAmount) TWD")
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: queue) {
            completion(String(ntBalance))
        }
    }

    func getCurrencies(accounts: [Account]) -> [String] {
        var currencies: [String] = []
        for account in accounts {
            currencies.append(account.currency)
        }
        return currencies
    }
    
    func addOverlayView() {
        guard !isOverlayViewAdded, let cell = myTableView.cellForRow(at: IndexPath(row: 0, section: 0)) else { return }
        isOverlayViewAdded = true
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.layer.cornerRadius = 6
        overlayView.layer.shadowColor = UIColor.black.cgColor
        overlayView.layer.shadowOpacity = 0.9
        overlayView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        overlayView.layer.shadowRadius = 4.0
        myTableView.addSubview(overlayView)

        overlayView.addSubview(totalLabel)
        overlayView.addSubview(eyesButton)
        overlayView.addSubview(moneyLabel)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: -50),
            overlayView.leadingAnchor.constraint(equalTo: myTableView.leadingAnchor, constant: 16),
            overlayView.trailingAnchor.constraint(equalTo: myTableView.trailingAnchor, constant: -16),
            overlayView.heightAnchor.constraint(equalToConstant: 100),
            overlayView.widthAnchor.constraint(equalToConstant: 360),
            
            totalLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 16),
            totalLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            
            eyesButton.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 16),
            eyesButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -236),
            eyesButton.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            eyesButton.widthAnchor.constraint(equalToConstant: 80),
            
            moneyLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 16),
            moneyLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            moneyLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            moneyLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -16)
        ])
        
        myTableView.bringSubviewToFront(overlayView)
    }
    
    @objc func eyesButtonTapped() {
        if moneyLabel.text == "NT$ ******" {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal

            if let inputNumber = inputNumber, let formattedNumber = numberFormatter.string(from: NSNumber(value: inputNumber)) {
                moneyLabel.text = "NT$ \(formattedNumber)"
            } else {
                moneyLabel.text = ""
            }
//            moneyLabel.text = "NT$ \(inputNumber!)"
        } else {
            moneyLabel.text = "NT$ ******"
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return producArray.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell
            cell?.setupICarouselView()
            return cell!
        } else if indexPath.row == 1 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell", for: indexPath) as? SecondTableViewCell
            return cell!
        } else {
            let cell = myTableView.dequeueReusableCell(withIdentifier: "ThirdTableViewCell", for: indexPath) as? ThirdTableViewCell
            let coinId = producArray[indexPath.row - 2]
            ApiManager.shared.getProductsStats(productId: coinId) { productStat in
                if let productStat = productStat {
                    let open = productStat.open
                    let last = productStat.last
                    let number = (Double(last)! - Double(open)!) / Double(last)! * 100
                    let formattedNumber = String(format: "%.2f", number)
                    let productInfo = ProductInfo.fromTableStatName(coinId)
                    DispatchQueue.main.async {
                        cell?.leftImageView.image = productInfo?.image
                        cell?.bottomLabel.text = productInfo?.chtName
                        cell?.chartBottomLabel.text = "\(formattedNumber)%"
                        cell?.updateLabelColor(with: number)
                        let high = (Double(productStat.high)! + Double(productStat.low)!) / 2
                        let highString = truncateDoubleToString(high)
                        getExchangeRate() { (exchangeRate) in
                            if let exchangeRate = exchangeRate {
                                let twdAmount = high * exchangeRate
                                DispatchQueue.main.async {
//                                    cell?.chartTopLabel.text = "\(twdAmount)"
                                    cell?.chartTopLabel.text = "\(highString)"
                                }
                                print("\(high) USD = \(twdAmount) TWD")
                            } else {
                                print("無法獲取匯率資料")
                            }
                        }
                    }
                }
            }
            let originalString = producArray[indexPath.row - 2]
            let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
            cell?.topLabel.text = modifiedString
            
//            self.realTimeDataHandler = { data in
//                // 处理每五秒收到的数据，例如更新UI或执行其他操作
//                print("Received real-time data: \(data)")
//            }
            
            return cell!
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 1 {
            // 取消點擊事件
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替换为您的故事板名称
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
        destinationVC?.hidesBottomBarWhenPushed = true
        destinationVC?.selectedCurrency = producArray[indexPath.row - 2]
        destinationVC?.userWalletAllCurrency = self.userWalletAllCurrency
        navigationController?.pushViewController(destinationVC!, animated: true)
    }
}

