//
//  TradeTableViewCell.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit

class TradeTableViewCell: UITableViewCell {
    
//    let topLabel1: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "BUY"
//        label.textAlignment = .center
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.layer.cornerRadius = 8
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.green.cgColor
//        label.backgroundColor = UIColor.clear
//        label.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
//        return label
//    }()
    let topLabel1: UIView = {
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

    
    let topLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2021-01-30 08:31"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        // 设置下面第一个标签的样式、内容等
        // ...
        return label
    }()
    
    let middleLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "購入 USDT"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        // 设置上面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    let middleLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1,065.340909"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        // 设置下面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    let imageView1: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "red")
        
        // 设置下面第一个标签的样式、内容等
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return image
    }()
    
    let bottomLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "成功"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        // 设置上面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    let bottomLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NT$ 30,000"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        // 设置下面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(){
        contentView.addSubview(topLabel1)
        contentView.addSubview(topLabel2)
        
        contentView.addSubview(middleLabel1)
        contentView.addSubview(middleLabel2)
        
        contentView.addSubview(imageView1)
        contentView.addSubview(bottomLabel1)
        contentView.addSubview(bottomLabel2)

        let margin: CGFloat = 16
        
        NSLayoutConstraint.activate([

            topLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            topLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            
            topLabel2.leadingAnchor.constraint(equalTo: topLabel1.trailingAnchor,constant: 8),
            topLabel2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            topLabel2.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -margin),
            topLabel2.centerYAnchor.constraint(equalTo: topLabel1.centerYAnchor),
            
            middleLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            middleLabel1.topAnchor.constraint(equalTo: topLabel1.bottomAnchor, constant: margin),
            middleLabel1.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: margin),
            
            middleLabel2.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: margin),
            middleLabel2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            middleLabel2.centerYAnchor.constraint(equalTo: middleLabel1.centerYAnchor),
            
            imageView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView1.topAnchor.constraint(equalTo: middleLabel1.bottomAnchor),
            imageView1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            
            bottomLabel1.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor),
            bottomLabel1.topAnchor.constraint(equalTo: middleLabel1.bottomAnchor),
            bottomLabel1.trailingAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            
            bottomLabel2.leadingAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            bottomLabel2.topAnchor.constraint(equalTo: middleLabel2.bottomAnchor),
            bottomLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
    }
}
