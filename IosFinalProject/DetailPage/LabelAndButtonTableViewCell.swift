//
//  LabelAndButtonTableViewCell.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit

import UIKit

class LabelAndButtonTableViewCell: UITableViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "交易紀錄"
        label.font = UIFont.systemFont(ofSize: 18,weight: .bold)
        // 設置 label 的屬性，例如文字、字體大小、顏色等
        // ...
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("查看全部", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        // 設置 button 的屬性，例如標題、字體大小、顏色等

        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            // Label constraints
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Button constraints
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
