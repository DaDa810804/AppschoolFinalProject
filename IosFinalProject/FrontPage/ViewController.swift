//
//  ViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/28.
//

import UIKit
import Starscream

class ViewController: UIViewController {

    
//    var realTimeDataHandler: (([String]) -> Void)?

    
    @IBOutlet weak var myTableView: UITableView!
    var isOverlayViewAdded = false
    var producArray: [String] = []
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
        label.font = UIFont.systemFont(ofSize: 30,weight: .medium)
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
        
//        let websocketService = WebsocketService.shared
//        websocketService.setWebsocket(currency: "BTC")
//        websocketService.realTimeData = { data in
//            // 处理每五秒收到的数据
//            self.realTimeDataHandler?(data)
//        }

        
        myTableView.delegate = self
        myTableView.dataSource = self
        moneyLabel.text = "NT$\(inputNumber!)"
        myTableView.contentInsetAdjustmentBehavior = .never
        addOverlayView()
        //Account、Product、ProductStats
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        ApiManager.shared.getProducts { products in
            self.producArray = products
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
        
        ApiManager.shared.getAccounts { accounts in
            guard let balance = self.getUSDBalance(accounts: accounts) else { return }
            getExchangeRate() { (exchangeRate) in
                if let exchangeRate = exchangeRate {
                    let twdAmount = (Double(balance) ?? 0.0) * exchangeRate
                    DispatchQueue.main.async {
                        self.moneyLabel.text = "NT$ \(Int(twdAmount))"
                        self.inputNumber = Int(twdAmount)
                    }
                    print("\(balance) USD = \(twdAmount) TWD")
                } else {
                    print("無法獲取匯率資料")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addOverlayView()
    }
    
    func getUSDBalance(accounts: [Account]) -> String? {
        for account in accounts {
            if account.currency == "USD" {
                return account.balance
            }
        }
        return nil
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
            moneyLabel.text = "NT$ \(inputNumber!)"
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
                        let high = (Double(productStat.high)! + Double(productStat.low)!) / 2
                        getExchangeRate() { (exchangeRate) in
                            if let exchangeRate = exchangeRate {
                                let twdAmount = high * exchangeRate
                                DispatchQueue.main.async {
                                    cell?.chartTopLabel.text = "\(Int(twdAmount))"
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
        navigationController?.pushViewController(destinationVC!, animated: true)
    }
}

