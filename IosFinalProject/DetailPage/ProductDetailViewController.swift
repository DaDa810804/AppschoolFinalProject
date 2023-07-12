//
//  ProductDetailViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit
import MJRefresh

class ProductDetailViewController: UIViewController {
    
    var realTimeDataHandler: (([String]) -> Void)?
    @IBOutlet weak var productDetailTableView: UITableView!
    var selectedCurrency: String?
    var ordersArray: [Order] = []
    var candlesArray: [Candles] = []
    var chartsArray: [Double] = []
    var userWalletAllCurrency: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = MJRefreshAutoNormalFooter()
        refreshControl.setTitle("上拉刷新", for: .idle)
        refreshControl.setTitle("釋放更新", for: .pulling)
        refreshControl.setTitle("正在刷新...", for: .refreshing)

        // 設置下拉刷新的回調方法
        refreshControl.refreshingBlock = { [weak self] in
            // 在這裡執行下拉刷新時的操作
            // 例如重新加載數據、獲取最新數據等
            // 完成後，使用 refreshControl.endRefreshing() 結束刷新
            self?.loadData()
        }
        productDetailTableView.mj_footer = refreshControl
        
        productDetailTableView.dataSource = self
        productDetailTableView.delegate = self
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isHidden = false
        //五秒傳值
        let websocketService = WebsocketService.shared
        websocketService.setWebsocket(currency: selectedCurrency!)
        websocketService.realTimeData = { data in
            // 处理每五秒收到的数据
            self.realTimeDataHandler?(data)
        }
        
        ApiManager.shared.getOrders(productId: selectedCurrency!) { orders,error in
            if let orders = orders {
                self.ordersArray = orders
                DispatchQueue.main.async {
                    self.productDetailTableView.reloadData()
                }
            }
        }
        guard let originalString = selectedCurrency else { return }
        let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
        navigationItem.title = "\(ProductInfo.fromTableStatName(originalString)!.chtName)(\(modifiedString))"
    }

    @IBAction func buyButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TradePageViewController") as? TradePageViewController
        let navController = UINavigationController(rootViewController: destinationVC!)
        navController.modalPresentationStyle = .fullScreen
        destinationVC?.hidesBottomBarWhenPushed = true
        destinationVC?.isBuying = true
        destinationVC?.modalPresentationStyle = .fullScreen
        destinationVC?.selectedCurrency = selectedCurrency
        present(navController, animated: true)
    }
    
    @IBAction func sellButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TradePageViewController") as? TradePageViewController
        let navController = UINavigationController(rootViewController: destinationVC!)
        navController.modalPresentationStyle = .fullScreen
        destinationVC?.hidesBottomBarWhenPushed = true
        destinationVC?.isBuying = false
        destinationVC?.modalPresentationStyle = .fullScreen
        destinationVC?.selectedCurrency = selectedCurrency
        present(navController, animated: true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cheekAllButtonTapped() {
        print("查看全部")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController
        guard let originalString = selectedCurrency else { return }
        let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
        hVC?.userWalletAllCurrency = self.userWalletAllCurrency
        hVC?.allCurrencyLabel.text = modifiedString//BTC
        //這邊進去的話要給他indexPath
        let indexPathRow = userWalletAllCurrency.firstIndex(of: modifiedString)! + 1
        let indexPath = IndexPath(row: indexPathRow, section: 0)
        UserDefaults.standard.set(indexPath.row, forKey: "SelectedCurrencyIndexPath")
        navigationController?.pushViewController(hVC!, animated: true)
    }
    
    func loadData() {
        ApiManager.shared.getOrders(productId: selectedCurrency!) { orders, error in
            if let orders = orders {
                self.ordersArray = orders
                DispatchQueue.main.async {
                    self.productDetailTableView.reloadData()
                    self.productDetailTableView.mj_footer?.endRefreshing()
                }
            } else {
                self.productDetailTableView.mj_footer?.endRefreshing()
            }
        }
    }
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ordersArray.isEmpty == false {
            return ordersArray.count + 3
        } else {
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let priceCell = productDetailTableView.dequeueReusableCell(withIdentifier: "PriceTableViewCell", for: indexPath) as? PriceTableViewCell else { return PriceTableViewCell() }
            priceCell.setupUI()
            self.realTimeDataHandler = { data in
                // 处理每五秒收到的数据，例如更新UI或执行其他操作
                DispatchQueue.main.async {
                    priceCell.bottomLabel1.text = "\(data.last!)"
                    priceCell.bottomLabel2.text = "\(data.first!)"
                }
                print("Received real-time data: \(data)")
            }
            priceCell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            return priceCell
        } else if indexPath.row == 1 {
            guard let chartsCell = productDetailTableView.dequeueReusableCell(withIdentifier: "ChartsTableViewCell", for: indexPath) as? ChartsTableViewCell else { return ChartsTableViewCell() }
            chartsCell.getPriceCell = {
                guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PriceTableViewCell else {
                    return PriceTableViewCell()
                }
                return cell
            }
            if let selectedCurrency = selectedCurrency {
                ApiManager.shared.fetchCandleData(productID: selectedCurrency, timeRange: TimeRange.oneDay) { candles, error in
                    print("candles\(candles)")
                    var chartsArray: [Double] = []
                    var dayArray: [Double] = []
                    if candles?.isEmpty == false {
                        print("有東西")
                        if let candles = candles {
                            for index in candles {
                                dayArray.append(index.time)
                                chartsArray.append((index.high + index.low) / 2)
                            }

                            DispatchQueue.main.async {
                                // 在主队列中更新单元格
                                if let chartsCell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ChartsTableViewCell {
                                    chartsCell.dayArray = dayArray.reversed()
                                    chartsCell.setChartView(dataArray: chartsArray.reversed())
                                    chartsCell.selectedCurrency = self.selectedCurrency
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            chartsCell.setChartView(dataArray: [0,0])
                            chartsCell.selectedCurrency = self.selectedCurrency
                        }
                    }
                }
            }

            return chartsCell
        } else if indexPath.row == 2 {
            guard let labelCell = productDetailTableView.dequeueReusableCell(withIdentifier: "LabelAndButtonTableViewCell", for: indexPath) as? LabelAndButtonTableViewCell else
            { return LabelAndButtonTableViewCell() }
            labelCell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
            labelCell.button.addTarget(self, action: #selector(cheekAllButtonTapped), for: .touchUpInside)
            return labelCell
        } else {
            guard let tradeCell = productDetailTableView.dequeueReusableCell(withIdentifier: "TradeTableViewCell", for: indexPath) as? TradeTableViewCell else { return TradeTableViewCell() }
            tradeCell.setupUI()
            let order = ordersArray[indexPath.row - 3]
            let side = order.side
            let modifiedString = order.productId.replacingOccurrences(of: "-USD", with: "")
            let middleLabel1Text = (side == "buy") ? "購入" : "賣出"
            let numberString = order.executedValue
            if let dotIndex = numberString.firstIndex(of: ".") {
                let endIndex = numberString.index(dotIndex, offsetBy: 9)
                let truncatedString = String(numberString[..<endIndex])
                tradeCell.setBottomLabel2Text("USD$ \(truncatedString)")
            }
            tradeCell.setTopLabelViewText("\(side)")
            tradeCell.setTopLabel2Text("\(timeChange(dateString: order.doneAt!))")
            tradeCell.setMiddleLabel1Text("\(middleLabel1Text) \(modifiedString)")
            tradeCell.setMiddleLabel2Text("\(order.size)")
            tradeCell.setBottomLabel1Text(order.status == "done" ? "成功" : order.status)
            return tradeCell
        }
    }
}
