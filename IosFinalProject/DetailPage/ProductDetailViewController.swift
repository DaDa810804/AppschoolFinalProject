//
//  ProductDetailViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var realTimeDataHandler: (([String]) -> Void)?
    @IBOutlet weak var productDetailTableView: UITableView!
    var selectedCurrency: String?
    var ordersArray: [Order] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailTableView.dataSource = self
        productDetailTableView.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //五秒傳值
        let websocketService = WebsocketService.shared
        websocketService.setWebsocket(currency: selectedCurrency!)
        websocketService.realTimeData = { data in
            // 处理每五秒收到的数据
            self.realTimeDataHandler?(data)
        }
        
        ApiManager.shared.getOrders(productId: selectedCurrency!) { orders in
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替换为您的故事板名称
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TradePageViewController") as? TradePageViewController
        destinationVC?.hidesBottomBarWhenPushed = true
        destinationVC?.isBuying = true
        destinationVC?.modalPresentationStyle = .fullScreen
        destinationVC?.selectedCurrency = selectedCurrency //之後是該頁面為何種幣別，再將其傳入
        present(destinationVC!, animated: true)
    }
    
    @IBAction func sellButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替换为您的故事板名称
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TradePageViewController") as? TradePageViewController
        destinationVC?.hidesBottomBarWhenPushed = true
        destinationVC?.isBuying = false
        destinationVC?.modalPresentationStyle = .fullScreen
        destinationVC?.selectedCurrency = selectedCurrency //之後是該頁面為何種幣別，再將其傳入
        present(destinationVC!, animated: true)
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
                    priceCell.bottomLabel1.text = "\(data.first!)"
                    priceCell.bottomLabel2.text = "\(data.last!)"
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
            return chartsCell
        } else if indexPath.row == 2 {
            guard let labelCell = productDetailTableView.dequeueReusableCell(withIdentifier: "LabelAndButtonTableViewCell", for: indexPath) as? LabelAndButtonTableViewCell else
            { return LabelAndButtonTableViewCell() }
            labelCell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
            return labelCell
        } else {
            guard let tradeCell = productDetailTableView.dequeueReusableCell(withIdentifier: "TradeTableViewCell", for: indexPath) as? TradeTableViewCell else { return TradeTableViewCell() }
            tradeCell.setupUI()
            let order = ordersArray[indexPath.row - 3]
            let side = order.side
            tradeCell.setTopLabelViewText("\(side)")
            tradeCell.setTopLabel2Text("\(timeChange(dateString: order.doneAt))")
            let originalString = order.productID
            let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
            
            tradeCell.setMiddleLabel1Text("\(side) \(modifiedString)")
            tradeCell.setMiddleLabel2Text("\(order.size)")
            tradeCell.setBottomLabel1Text("\(order.status)")
            tradeCell.setBottomLabel2Text("\(order.price)")
            return tradeCell
        }
    }
}
