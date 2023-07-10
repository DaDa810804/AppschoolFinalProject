//
//  SuccessfulTransactionViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/5.
//

import UIKit

class SuccessfulTransactionViewController: UIViewController {
    
    var orderData: Order?
    
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
    
    let successfulImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Sucess1x")
        image.widthAnchor.constraint(equalToConstant: 120).isActive = true
        image.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return image
    }()
    
    let separatorView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    let stateLabelView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 4
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.myGreen.cgColor
        container.backgroundColor = UIColor.myGreen
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BUY"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14,weight: .bold)
        
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        return container
    }()
    
    let howManyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.text = "12345"
        return label
    }()
    
    let separatorView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    let orderTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "下單時間"
        return label
    }()
    
    let orderTimeRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.text = "12345"
        return label
    }()
    
    let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "更新時間"
        return label
    }()
    
    let updateTimeRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.text = "12345"
        return label
    }()
    
    let unitPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "單位價格"
        return label
    }()
    
    let unitPriceRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.text = "12345"
        return label
    }()
    
    let separatorView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let amountsPayableLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .myRed
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "應付金額"
        return label
    }()
    
    let amountsPayableRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .right
        label.text = "12345"
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0

        let phoneNumber = "(02)2722-1314"
        let emailAddress = "info@maicoin.com"
        let fullText = "訂單相關問題，請撥打客服專線\(phoneNumber)或來信至\(emailAddress)"

        let attributedString = NSMutableAttributedString(string: fullText)

        // 設定電話號碼的樣式（底線、藍色）
        let phoneNumberRange = (fullText as NSString).range(of: phoneNumber)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: phoneNumberRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: phoneNumberRange)

        // 設定電子郵件地址的樣式（底線、藍色）
        let emailRange = (fullText as NSString).range(of: emailAddress)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: emailRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: emailRange)

        label.attributedText = attributedString

        return label
    }()
    
    let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("確認我的資產", for: .normal)
        button.backgroundColor = .myRed
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    let backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return backButton
    }()
    
    let backButtonRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "訂單詳情"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroudView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let order = orderData else { return }
        let originalString = order.productId
        let modifiedString = originalString.replacingOccurrences(of: "-USD", with: "")
        let unit = (Double(order.executedValue)! - Double(order.fillFees)!) / Double(order.size)!
        setTopLabelViewText(order.side)
        howManyLabel.text = "\(order.size) \(modifiedString)"
        orderTimeRightLabel.text = timeChange(dateString: order.createdAt)
        updateTimeRightLabel.text = timeChange(dateString: (order.doneAt) ?? "")
        unitPriceRightLabel.text = "USD$ \(String(format: "%.2f", unit))"
        amountsPayableRightLabel.text = "USD$ \(String(format: "%.2f", Double(order.executedValue)!))"
        if order.side == "buy" {
            amountsPayableLabel.text = "應付金額"
        } else {
            amountsPayableLabel.text = "獲得金額"
        }
    }
    
    func setBackgroudView() {
        view.addSubview(redView)
        view.addSubview(grayView)
        view.addSubview(overlayView)
        view.addSubview(successfulImage)
        view.addSubview(separatorView1)
        view.addSubview(stateLabelView)
        view.addSubview(howManyLabel)
        view.addSubview(separatorView2)
        view.addSubview(orderTimeLabel)
        view.addSubview(orderTimeRightLabel)
        view.addSubview(updateTimeLabel)
        view.addSubview(updateTimeRightLabel)
        view.addSubview(unitPriceLabel)
        view.addSubview(unitPriceRightLabel)
        view.addSubview(separatorView3)
        view.addSubview(amountsPayableLabel)
        view.addSubview(amountsPayableRightLabel)
        view.addSubview(bottomLabel)
        view.addSubview(bottomButton)
        view.addSubview(backButton)
        view.addSubview(backButtonRightLabel)
        
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            redView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            grayView.topAnchor.constraint(equalTo: redView.bottomAnchor),
            grayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: redView.centerYAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            overlayView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.5),
            
            successfulImage.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 16),
            successfulImage.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            
            separatorView1.topAnchor.constraint(equalTo: successfulImage.bottomAnchor, constant: 16),
            separatorView1.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            separatorView1.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            separatorView1.heightAnchor.constraint(equalToConstant: 1),
            
            stateLabelView.topAnchor.constraint(equalTo: separatorView1.bottomAnchor, constant: 16),
            stateLabelView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            stateLabelView.bottomAnchor.constraint(equalTo: separatorView2.topAnchor, constant: -16),
            stateLabelView.heightAnchor.constraint(equalToConstant: 25),
            
            howManyLabel.topAnchor.constraint(equalTo: separatorView1.bottomAnchor, constant: 16),
            howManyLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            howManyLabel.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            howManyLabel.bottomAnchor.constraint(equalTo: separatorView2.topAnchor, constant: -16),
            
            separatorView2.topAnchor.constraint(equalTo: stateLabelView.bottomAnchor, constant: 16),
            separatorView2.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            separatorView2.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            separatorView2.heightAnchor.constraint(equalToConstant: 1),
            
            orderTimeLabel.topAnchor.constraint(equalTo: separatorView2.bottomAnchor, constant: 16),
            orderTimeLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            orderTimeLabel.trailingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            
            orderTimeRightLabel.topAnchor.constraint(equalTo: separatorView2.bottomAnchor, constant: 16),
            orderTimeRightLabel.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            orderTimeRightLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),

            updateTimeLabel.topAnchor.constraint(equalTo: orderTimeLabel.bottomAnchor, constant: 16),
            updateTimeLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            updateTimeLabel.trailingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            
            updateTimeRightLabel.topAnchor.constraint(equalTo: orderTimeRightLabel.bottomAnchor, constant: 16),
            updateTimeRightLabel.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            updateTimeRightLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            
            unitPriceLabel.topAnchor.constraint(equalTo: updateTimeLabel.bottomAnchor, constant: 16),
            unitPriceLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            unitPriceLabel.trailingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            
            unitPriceRightLabel.topAnchor.constraint(equalTo: updateTimeRightLabel.bottomAnchor, constant: 16),
            unitPriceRightLabel.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            unitPriceRightLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            
            separatorView3.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            separatorView3.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            separatorView3.heightAnchor.constraint(equalToConstant: 1),
            
            amountsPayableLabel.topAnchor.constraint(equalTo: separatorView3.bottomAnchor, constant: 16),
            amountsPayableLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            amountsPayableLabel.trailingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            
            amountsPayableRightLabel.topAnchor.constraint(equalTo: separatorView3.bottomAnchor, constant: 16),
            amountsPayableRightLabel.leadingAnchor.constraint(equalTo: overlayView.centerXAnchor),
            amountsPayableRightLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            amountsPayableLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -16),
            
            bottomLabel.topAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: 16),
            bottomLabel.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 32),
            bottomLabel.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -32),
            
            bottomButton.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 16),
            bottomButton.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -16),
            bottomButton.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -32),
            
//            backButton.topAnchor.constraint(equalTo: redView.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: redView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: overlayView.topAnchor, constant: -24),
            
            backButtonRightLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            backButtonRightLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
            
        ])
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func bottomButtonTapped() {
        print("跑去錢包頁面")
        if let tabBarController = presentingViewController as? UITabBarController {
            let desiredIndex = 1
            
            if desiredIndex >= 0 && desiredIndex < tabBarController.viewControllers?.count ?? 0 {
                tabBarController.selectedIndex = desiredIndex
            }
            
            UIView.animate(withDuration: 1, animations: {}) { _ in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func setTopLabelViewText(_ text: String) {
        if let label = stateLabelView.subviews.compactMap({ $0 as? UILabel }).first {
            label.text = text
        }
    }
}
