//
//  switchCurrencyTableViewCell.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/6.
//

import UIKit

class SwitchCurrencyTableViewCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "link")
        // 设置左侧图片视图的样式、内容等
        // ...
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USDT"
        // 设置上方标签的样式、内容等
        // ...
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(currencyLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            currencyLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            currencyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
