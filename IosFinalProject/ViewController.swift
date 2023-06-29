//
//  ViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/28.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    var inputNumber: Int? = 1234
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
        myTableView.delegate = self
        myTableView.dataSource = self
        moneyLabel.text = "NT$\(inputNumber!)"
    }
    override func viewDidAppear(_ animated: Bool) {
        addOverlayView()
    }
    
    func addOverlayView() {
        guard let cell = myTableView.cellForRow(at: IndexPath(row: 0, section: 0)) else { return }
        
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
        return 3
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

            return cell!
        }

    }
}

