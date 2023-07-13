//
//  TradePageViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit
import IQKeyboardManagerSwift
import JGProgressHUD

class TradePageViewController: UIViewController {
    var realTimeDataHandler: (([String]) -> Void)?
    var isBuying: Bool?
    var selectedCurrency: String?
    var instantAmount: String = "0"
    let availableBalanceLabel = UILabel()
    let myHud = JGProgressHUD()
    var availableBalance: Double?
    var isTopTextFieldEditable = true
    var buyPrice: Double? {
        didSet {
            // 当buyPrice的值发生更改时，重新计算计算值
            if isTopTextFieldEditable == true {
                //上方文字輸入匡可以編輯
                if let text = topTextField.text, let buyPrice = buyPrice, let number = Double(text) {
                    let calculatedValue = number * buyPrice
                    bottomTextField.text = String(format: "%.6f", calculatedValue)
                } else {
                    bottomTextField.text = ""
                }
            } else {
                //下方文字輸入匡可以編輯
                if let text = bottomTextField.text,let buyPrice = buyPrice, let number = Double(text) {
                    let calculatedValue = number / buyPrice
                    topTextField.text = String(format: "%.6f", calculatedValue)
                } else {
                    topTextField.text = ""
                }
            }
        }
    }
    
    let redView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .myRed
        return view
    }()
    
    let grayView: UIView = {
        let grayView = UIView()
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.backgroundColor = .myLightGray
        return grayView
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    let currencyLabel: UILabel = {
        let currencyLabel = UILabel()
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.textColor = .white
        currencyLabel.font = UIFont.boldSystemFont(ofSize: 16)
        currencyLabel.textAlignment = .center
        return currencyLabel
    }()
    
    let topTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .gray
        textField.borderStyle = .none
        return textField
    }()
    
    let bottomTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .gray
        textField.borderStyle = .none
        return textField
    }()
    
    let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .myRed
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myHud.textLabel.text = "Loading"
        bottomTextField.keyboardType = .decimalPad
        bottomTextField.returnKeyType = .done
        topTextField.keyboardType = .decimalPad
        topTextField.returnKeyType = .done
        bottomTextField.isUserInteractionEnabled = false
        bottomTextField.placeholder = ""
        topTextField.addTarget(self, action: #selector(topTextFieldChanged(_:)), for: .editingChanged)
        bottomTextField.addTarget(self, action: #selector(bottomTextFieldChanged(_:)), for: .editingChanged)
        setBackgroudView()
        setupCancelButton()
        setupCurrencyLabel()
        addElementsToOverlayView()
        topTextField.delegate = self
        bottomTextField.delegate = self
        self.realTimeDataHandler = { data in
            // 处理每五秒收到的数据，例如更新UI或执行其他操作
            DispatchQueue.main.async {
                let valueToUpdate = self.isBuying == true ? data.last : data.first
                guard let originalString = self.selectedCurrency else { return }
                let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
                let text = "1 \(modifiedString ?? "") = \(valueToUpdate ?? "") USD"
                let attributedText = NSMutableAttributedString(string: text)
                self.buyPrice = Double(valueToUpdate!)
                if let value = valueToUpdate {
                    let range = (text as NSString).range(of: "\(value)")
                    attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)], range: range)
                }
                
                self.currencyLabel.attributedText = attributedText
            }

            print("第二頁Received real-time data: \(data)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        ApiManager.shared.getAccounts { accounts in
            guard let originalString = self.selectedCurrency else { return }
            let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
            if let balance = self.getCurrencyBalance(accounts: accounts,productID: modifiedString) {
                DispatchQueue.main.async {
                    if let number = Double(balance) {
                        let formatter = NumberFormatter()
                        formatter.minimumFractionDigits = 2
                        formatter.maximumFractionDigits = 2
                        
                        if let formattedString = formatter.string(from: NSNumber(value: number)) {
                            self.availableBalanceLabel.text = "可用餘額: \(formattedString) \(modifiedString)"
                            self.availableBalance = Double(formattedString)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.availableBalanceLabel.text = "可用餘額: 0.00 \(modifiedString)"
                }
            }
        }
        setupTradeLimitsLabel()
        setupBottomButton()
        let websocketService = WebsocketService.shared
        websocketService.setWebsocket(currency: selectedCurrency!)
        websocketService.realTimeData = { [weak self] data in
            // 处理每五秒收到的数据
            self?.realTimeDataHandler?(data)
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addOverlayView()
    }
    
    func setBackgroudView() {
        view.addSubview(redView)
        view.addSubview(grayView)

        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            redView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            grayView.topAnchor.constraint(equalTo: redView.bottomAnchor),
            grayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addOverlayView() {
        view.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: redView.topAnchor, constant: redView.frame.height * 3 / 4),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            overlayView.heightAnchor.constraint(equalTo: redView.heightAnchor,constant: -40)
        ])
    }
    
    func setupCancelButton() {
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = .white
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        view.addSubview(cancelButton)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18,weight: .bold)
        guard let originalString = selectedCurrency else { return }
        let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
        if let isBuying = isBuying, isBuying {
            label.text = "買入 \(modifiedString)"
        } else {
            label.text = "賣出 \(modifiedString)"
        }
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            label.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 30),
            label.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor)
        ])
    }
    
    func setupCurrencyLabel() {
        guard let originalString = selectedCurrency else { return }
        let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
        let text = "1 \(modifiedString ?? "") = \(instantAmount) USD"
        let attributedText = NSMutableAttributedString(string: text)
        
        let range = (text as NSString).range(of: "\(instantAmount)")
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)], range: range)
        
        currencyLabel.attributedText = attributedText
        redView.addSubview(currencyLabel)
        
        NSLayoutConstraint.activate([
            currencyLabel.centerXAnchor.constraint(equalTo: redView.centerXAnchor),
            currencyLabel.centerYAnchor.constraint(equalTo: redView.centerYAnchor,constant: 30)
        ])
    }
    
    func setupTradeLimitsLabel() {
        let tradeLimitsLabel = UILabel()
        tradeLimitsLabel.translatesAutoresizingMaskIntoConstraints = false
        tradeLimitsLabel.textColor = .black
        tradeLimitsLabel.font = UIFont.systemFont(ofSize: 16)
        tradeLimitsLabel.textAlignment = .center
        tradeLimitsLabel.numberOfLines = 0
        
        if let isBuying = isBuying, isBuying {
            // 购买模式
            tradeLimitsLabel.text = "0.00002 BTC ≤ 單筆買入額度 ≤ 2 BTC"
            view.addSubview(tradeLimitsLabel)
            NSLayoutConstraint.activate([
                tradeLimitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tradeLimitsLabel.topAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        } else {
            // 卖出模式
            tradeLimitsLabel.text = "0.00002 BTC ≤ 單筆賣出額度 ≤ 2 BTC"
//            let availableBalanceLabel = UILabel()
            availableBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
            availableBalanceLabel.textColor = .black
            availableBalanceLabel.font = UIFont.systemFont(ofSize: 16)
            availableBalanceLabel.textAlignment = .center
            availableBalanceLabel.text = "可用餘額: 5 BTC" // 替换为实际可用的币种余额
            
            let maxButton = UIButton(type: .system)
            maxButton.translatesAutoresizingMaskIntoConstraints = false
            maxButton.setTitle("Max", for: .normal)
            maxButton.setTitleColor(.blue, for: .normal)
            maxButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            maxButton.addTarget(self, action: #selector(maxButtonTapped), for: .touchUpInside)
            
            let stackView = UIStackView(arrangedSubviews: [availableBalanceLabel, maxButton])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.spacing = 8
            
            let limitsStackView = UIStackView(arrangedSubviews: [stackView, tradeLimitsLabel])
            limitsStackView.translatesAutoresizingMaskIntoConstraints = false
            limitsStackView.axis = .vertical
            limitsStackView.alignment = .center
            limitsStackView.spacing = 8
            
            view.addSubview(limitsStackView)
            
            NSLayoutConstraint.activate([
                limitsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                limitsStackView.topAnchor.constraint(equalTo: view.centerYAnchor),
                
                tradeLimitsLabel.leadingAnchor.constraint(equalTo: limitsStackView.leadingAnchor),
                tradeLimitsLabel.trailingAnchor.constraint(equalTo: limitsStackView.trailingAnchor),
                tradeLimitsLabel.bottomAnchor.constraint(equalTo: limitsStackView.bottomAnchor)
            ])
        }
    }

    func addElementsToOverlayView() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(changeInputButton), for: .touchUpInside)
        overlayView.addSubview(button)
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        overlayView.addSubview(separatorView)
        
        guard let originalString = selectedCurrency else { return }
        let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
        let lowercaseString = modifiedString.lowercased()
        let currencyIconImageView = UIImageView(image: UIImage(named: lowercaseString)) // 替换为实际的币种图标
        currencyIconImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(currencyIconImageView)
        
        let currencyLabel = UILabel()
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.text = modifiedString // 替换为实际的币种名称
        overlayView.addSubview(currencyLabel)
        
        let arrowButton = UIButton(type: .system)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        arrowButton.tintColor = .black
        arrowButton.isHidden = true
        overlayView.addSubview(arrowButton)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if isBuying == true {
            label.text = "買入"
        } else {
            label.text = "賣出"
        }
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        overlayView.addSubview(label)

        overlayView.addSubview(topTextField)
        
        let bottomCurrencyIconImageView = UIImageView(image: UIImage(named: "usd")) // 替换为实际的币种图标
        bottomCurrencyIconImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(bottomCurrencyIconImageView)
        
        let bottomCurrencyLabel = UILabel()
        bottomCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomCurrencyLabel.text = "USDC" // 替换为实际的币种名称
        overlayView.addSubview(bottomCurrencyLabel)
        
        let bottomArrowButton = UIButton(type: .system)
        bottomArrowButton.translatesAutoresizingMaskIntoConstraints = false
        bottomArrowButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        bottomArrowButton.tintColor = .black
        bottomArrowButton.isHidden = true
        overlayView.addSubview(bottomArrowButton)
        
        let bottomLabel = UILabel()
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        if isBuying == true {
            bottomLabel.text = "花費"
        } else {
            bottomLabel.text = "獲得"
        }
        bottomLabel.font = UIFont.systemFont(ofSize: 14)
        bottomLabel.textColor = .gray
        overlayView.addSubview(bottomLabel)
        overlayView.addSubview(bottomTextField)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 32),
            button.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            separatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            currencyIconImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            currencyIconImageView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 32),
            currencyIconImageView.widthAnchor.constraint(equalToConstant: 45),
            currencyIconImageView.heightAnchor.constraint(equalToConstant: 45),
            
            bottomCurrencyIconImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            bottomCurrencyIconImageView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -32),
            bottomCurrencyIconImageView.widthAnchor.constraint(equalToConstant: 45),
            bottomCurrencyIconImageView.heightAnchor.constraint(equalToConstant: 45),
            
            currencyLabel.leadingAnchor.constraint(equalTo: currencyIconImageView.trailingAnchor, constant: 8),
            currencyLabel.centerYAnchor.constraint(equalTo: currencyIconImageView.centerYAnchor),
            
            bottomCurrencyLabel.leadingAnchor.constraint(equalTo: bottomCurrencyIconImageView.trailingAnchor, constant: 8),
            bottomCurrencyLabel.centerYAnchor.constraint(equalTo: bottomCurrencyIconImageView.centerYAnchor),
            
            arrowButton.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 20),
            arrowButton.centerYAnchor.constraint(equalTo: currencyIconImageView.centerYAnchor),
            bottomArrowButton.leadingAnchor.constraint(equalTo: bottomCurrencyLabel.trailingAnchor, constant: 20),
            bottomArrowButton.centerYAnchor.constraint(equalTo: bottomCurrencyIconImageView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor,constant: -6),
            label.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 16),
            bottomLabel.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor,constant: -6),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomTextField.topAnchor,constant: -16),
            topTextField.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor,constant: -8),
            topTextField.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            topTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            topTextField.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -16),
            bottomTextField.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor,constant: -8),
            bottomTextField.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            bottomTextField.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 8),
            bottomTextField.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -24)
        ])
    }
    
    func setupBottomButton() {
        if let isBuying = isBuying, isBuying {
            // 购买模式
            bottomButton.setTitle("買入", for: .normal)
            bottomButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        } else {
            // 卖出模式
            bottomButton.setTitle("賣出", for: .normal)
            bottomButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        }
        
        view.addSubview(bottomButton)
        
        NSLayoutConstraint.activate([
            bottomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -48),
            bottomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func changeInputButton() {
        
        if isTopTextFieldEditable  == false {
            topTextField.isUserInteractionEnabled = true
            bottomTextField.isUserInteractionEnabled = false
            topTextField.backgroundColor = .white
            bottomTextField.placeholder = ""
            topTextField.placeholder = "Enter"
            isTopTextFieldEditable = true
        } else {
            topTextField.isUserInteractionEnabled = false
            bottomTextField.isUserInteractionEnabled = true
            topTextField.placeholder = ""
            bottomTextField.placeholder = "Enter"
            bottomTextField.backgroundColor = .white
            isTopTextFieldEditable = false
        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func maxButtonTapped() {
        //取得使用者該幣別的總額，並傳給textField
        guard let availableBalance = availableBalance else { return }
        topTextField.text = "\(availableBalance)"
        bottomTextField.text = "\(availableBalance * buyPrice!)"
    }
    
    @objc func buyButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let stvc = storyboard.instantiateViewController(withIdentifier: "SuccessfulTransactionViewController") as? SuccessfulTransactionViewController
        myHud.show(in: view)
        if let text = topTextField.text, let number = Double(text) {
            // 文字轉換為Double成功
            if number <= 2.0 && number >= 0.00002 {
                print("可以買賣")
                ApiManager.shared.creatOrder(size: "\(number)", side: "buy", productId: selectedCurrency!) {
                    responseOrder in
                    if let orderID = responseOrder?.id {
                        ApiManager.shared.getOrderForId(id: orderID) { order in
                            if let order = order {
                                stvc?.orderData = order
                                DispatchQueue.main.async {
                                    self.topTextField.text = ""
                                    self.myHud.dismiss()
                                    self.navigationController?.pushViewController(stvc!, animated: true)
                                }
                            } else {
                                showAlert(title: "錯誤", message: "訂單查詢失敗，請至歷史交易頁面查詢")
                                self.myHud.dismiss()
                            }
                        }
                    } else {
                        showAlert(title: "錯誤", message: "訂單建立失敗")
                        self.myHud.dismiss()
                    }
                }
            } else {
                self.myHud.dismiss()
                print("不能買賣")
                showAlert(title: "錯誤", message: "超出可買賣範圍")
            }
        } else {
            self.myHud.dismiss()
            showAlert(title: "錯誤", message: "請輸入金額")
            print("無效的格式")
        }

    }
    
    @objc func sellButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let stvc = storyboard.instantiateViewController(withIdentifier: "SuccessfulTransactionViewController") as? SuccessfulTransactionViewController
        myHud.show(in: view)
        if let text = topTextField.text, let number = Double(text) {
            // 文字轉換為Double成功
            if number <= 2.0 && number >= 0.00002 {
                print("可以買賣")
                ApiManager.shared.creatOrder(size: "\(number)", side: "sell", productId: selectedCurrency!) {
                    responseOrder in
                    if let orderID = responseOrder?.id {
                        ApiManager.shared.getOrderForId(id: orderID) { order in
                            if let order = order {
                                stvc?.orderData = order
                                DispatchQueue.main.async {
                                    self.topTextField.text = ""
                                    self.myHud.dismiss()
                                    self.navigationController?.pushViewController(stvc!, animated: true)
                                }
                            } else {
                                showAlert(title: "錯誤", message: "訂單查詢失敗，請至歷史交易頁面查詢")
                                self.myHud.dismiss()
                            }
                        }
                    } else {
                        showAlert(title: "錯誤", message: "訂單建立失敗")
                        self.myHud.dismiss()
                    }
                }
            } else {
                print("不能買賣")
                self.myHud.dismiss()
                showAlert(title: "錯誤", message: "超出可買賣範圍")
            }
        } else {
            self.myHud.dismiss()
            showAlert(title: "錯誤", message: "請輸入金額")
            print("無效的格式")
        }
    }
    
    @objc func topTextFieldChanged(_ textField: UITextField) {
        if let text = textField.text,let buyPrice = buyPrice,
           let number = Double(text) {
            let price = Double(buyPrice)
            let calculatedValue = number * price
            bottomTextField.text = String(format: "%.6f", calculatedValue)
        } else {
            bottomTextField.text = ""
        }
    }

    @objc func bottomTextFieldChanged(_ textField: UITextField) {
        if let text = textField.text,let buyPrice = buyPrice,
           let number = Double(text) {
            let calculatedValue = number / buyPrice
            topTextField.text = String(format: "%.6f", calculatedValue)
        } else {
            topTextField.text = ""
        }
    }
    
    func getCurrencyBalance(accounts: [Account], productID: String) -> String? {
        for account in accounts {
            if account.currency == productID {
                return account.balance
            }
        }
        return nil
    }
}

extension TradePageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 關閉鍵盤
        return true
    }
}
