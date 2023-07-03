//
//  TradePageViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit

class TradePageViewController: UIViewController {
    
    var isBuying: Bool?
    var selectedCurrency: String?
    
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
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter text"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .gray
        textField.borderStyle = .none
        return textField
    }()
    
    let bottomTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter text"
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
        guard let originalString = selectedCurrency else { return }
        let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
        selectedCurrency = modifiedString
        setBackgroudView()
        setupCancelButton()
        setupCurrencyLabel()
        addElementsToOverlayView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTradeLimitsLabel()
        setupBottomButton()
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
        if let isBuying = isBuying, isBuying {
            label.text = "買入 \(selectedCurrency!)"
        } else {
            label.text = "賣出 \(selectedCurrency!)"
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
        let currencyLabel = UILabel()
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.textColor = .white
        currencyLabel.font = UIFont.boldSystemFont(ofSize: 16)
        currencyLabel.textAlignment = .center
        
        let text = "1 \(selectedCurrency ?? "") = 2,500,000 TWD"
        let attributedText = NSMutableAttributedString(string: text)
        
        let range = (text as NSString).range(of: "2,500,000")
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
            let availableBalanceLabel = UILabel()
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
        overlayView.addSubview(button)
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        overlayView.addSubview(separatorView)
        
        let currencyIconImageView = UIImageView(image: UIImage(named: "usdt")) // 替换为实际的币种图标
        currencyIconImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(currencyIconImageView)
        
        let currencyLabel = UILabel()
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.text = selectedCurrency // 替换为实际的币种名称
        overlayView.addSubview(currencyLabel)
        
        let arrowButton = UIButton(type: .system)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        arrowButton.tintColor = .black
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

        overlayView.addSubview(textField)
        
        let bottomCurrencyIconImageView = UIImageView(image: UIImage(named: "usdt")) // 替换为实际的币种图标
        bottomCurrencyIconImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(bottomCurrencyIconImageView)
        
        let bottomCurrencyLabel = UILabel()
        bottomCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomCurrencyLabel.text = selectedCurrency // 替换为实际的币种名称
        overlayView.addSubview(bottomCurrencyLabel)
        
        let bottomArrowButton = UIButton(type: .system)
        bottomArrowButton.translatesAutoresizingMaskIntoConstraints = false
        bottomArrowButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        bottomArrowButton.tintColor = .black
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
            textField.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor,constant: -8),
            textField.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -16),
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
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func maxButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buyButtonTapped() {
        print("買東西")
    }
    
    @objc func sellButtonTapped() {
        print("賣東西")
    }
}
