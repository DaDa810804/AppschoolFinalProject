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
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
    
    let topLabelView: UIView = {
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
        label.textAlignment = .left
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
        contentView.addSubview(topLabelView)
        contentView.addSubview(topLabel2)
        
        contentView.addSubview(middleLabel1)
        contentView.addSubview(middleLabel2)
        
        contentView.addSubview(imageView1)
        contentView.addSubview(bottomLabel1)
        contentView.addSubview(bottomLabel2)

        let margin: CGFloat = 16
        
        NSLayoutConstraint.activate([

            topLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            topLabelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            topLabelView.widthAnchor.constraint(equalToConstant: 40),
            
            topLabel2.leadingAnchor.constraint(equalTo: topLabelView.trailingAnchor,constant: 8),
            topLabel2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            topLabel2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            topLabel2.centerYAnchor.constraint(equalTo: topLabelView.centerYAnchor),
            
            middleLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            middleLabel1.topAnchor.constraint(equalTo: topLabelView.bottomAnchor, constant: margin),
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
        
        setTopLabelViewText("BUY")
        
        // 设置topLabel2的文本
        setTopLabel2Text("2021-01-30 08:31")
        
        // 设置middleLabel1的文本
        setMiddleLabel1Text("購入 USDT")
        
        // 设置middleLabel2的文本
        setMiddleLabel2Text("1,065.340909")
        
        // 设置bottomLabel1的文本
        setBottomLabel1Text("成功")
        
        // 设置bottomLabel2的文本
        setBottomLabel2Text("NT$ 30,000")
    }
    

    func setTopLabelViewText(_ text: String) {
        if let label = topLabelView.subviews.compactMap({ $0 as? UILabel }).first {
            label.text = text
        }
    }

    func setTopLabel2Text(_ text: String) {
        topLabel2.text = text
    }

    func setMiddleLabel1Text(_ text: String) {
        middleLabel1.text = text
    }

    func setMiddleLabel2Text(_ text: String) {
        middleLabel2.text = text
    }

    func setBottomLabel1Text(_ text: String) {
        bottomLabel1.text = text
    }

    func setBottomLabel2Text(_ text: String) {
        bottomLabel2.text = text
    }

}
