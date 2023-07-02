//
//  ProductDetailViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailTableView.dataSource = self
        productDetailTableView.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func buyButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替换为您的故事板名称
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TradePageViewController") as? TradePageViewController
        destinationVC?.hidesBottomBarWhenPushed = true
        destinationVC?.isBuying = true
        destinationVC?.modalPresentationStyle = .fullScreen
        destinationVC?.selectedCurrency = "BTC" //之後是該頁面為何種幣別，再將其傳入
        present(destinationVC!, animated: true)
    }
    
    @IBAction func sellButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 替换为您的故事板名称
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TradePageViewController") as? TradePageViewController
        destinationVC?.hidesBottomBarWhenPushed = true
        destinationVC?.isBuying = false
        destinationVC?.modalPresentationStyle = .fullScreen
        destinationVC?.selectedCurrency = "BTC" //之後是該頁面為何種幣別，再將其傳入
        present(destinationVC!, animated: true)
    }
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let priceCell = productDetailTableView.dequeueReusableCell(withIdentifier: "PriceTableViewCell", for: indexPath) as? PriceTableViewCell else { return UITableViewCell() }
            priceCell.setupUI()
            priceCell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            return priceCell
        } else if indexPath.row == 1 {
            guard let chartsCell = productDetailTableView.dequeueReusableCell(withIdentifier: "ChartsTableViewCell", for: indexPath) as? ChartsTableViewCell else { return UITableViewCell() }
            
            chartsCell.getPriceCell = {
                guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PriceTableViewCell else {
                    return PriceTableViewCell()
                }
                
                return cell
            }
            
            return chartsCell
        } else if indexPath.row == 2 {
            guard let labelCell = productDetailTableView.dequeueReusableCell(withIdentifier: "LabelAndButtonTableViewCell", for: indexPath) as? LabelAndButtonTableViewCell else
            { return UITableViewCell() }
            labelCell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
            return labelCell
        } else {
            guard let tradeCell = productDetailTableView.dequeueReusableCell(withIdentifier: "TradeTableViewCell", for: indexPath) as? TradeTableViewCell else { return UITableViewCell() }
            tradeCell.setupUI()
            return tradeCell
        }
    }
}
