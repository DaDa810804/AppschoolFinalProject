//
//  PriceTableViewCell.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit

class PriceTableViewCell: UITableViewCell {
    
    let topLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "即時買價 NT$"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        // 设置上面第一个标签的样式、内容等
        // ...
        return label
    }()
    
    let bottomLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "30.708"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        // 设置上面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    let topLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "即時賣價 NT$"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        // 设置下面第一个标签的样式、内容等
        // ...
        return label
    }()
    
    let bottomLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "30.432"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        // 设置下面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    let middleLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "歷史均價 NT$"
        label.isHidden = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        // 设置下面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    let middleLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "22.432"
        label.isHidden = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        // 设置下面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    let middleLabel3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2023-05-27 08:00"
        label.isHidden = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        // 设置下面第二个标签的样式、内容等
        // ...
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupMiddleUI()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(){
        contentView.addSubview(topLabel1)
        contentView.addSubview(topLabel2)
        contentView.addSubview(bottomLabel1)
        contentView.addSubview(bottomLabel2)
        
        let margin: CGFloat = 16
        
        NSLayoutConstraint.activate([
            // 上面第一个标签约束
            topLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            topLabel1.trailingAnchor.constraint(equalTo: centerXAnchor,constant: -margin),
            topLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
//            topLabel1.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -margin),
            
            // 上面第二个标签约束
            topLabel2.leadingAnchor.constraint(equalTo: centerXAnchor,constant: margin),
            topLabel2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            topLabel2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
//            topLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            
            // 下面第一个标签约束
            bottomLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            bottomLabel1.topAnchor.constraint(equalTo: centerYAnchor),
            bottomLabel1.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -margin),
            bottomLabel1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            
            // 下面第二个标签约束
            bottomLabel2.leadingAnchor.constraint(equalTo: centerXAnchor, constant: margin),
            bottomLabel2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            bottomLabel2.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            bottomLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
    }
    
    func setupMiddleUI() {
        contentView.addSubview(middleLabel1)
        contentView.addSubview(middleLabel2)
        contentView.addSubview(middleLabel3)
        
        NSLayoutConstraint.activate([
            // 上面第一个标签约束
            middleLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            middleLabel1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            middleLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            // 上面第二个标签约束
            middleLabel2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            middleLabel2.topAnchor.constraint(equalTo: middleLabel1.bottomAnchor, constant: 16),
            middleLabel2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // 上面第三个标签约束
            middleLabel3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            middleLabel3.topAnchor.constraint(equalTo: middleLabel2.bottomAnchor,constant: 16),
            middleLabel3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            middleLabel3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
        ])
    }
    
    func hideLabels() {
        DispatchQueue.main.async {
            self.bottomLabel1.isHidden = true
            self.bottomLabel2.isHidden = true
            self.topLabel1.isHidden = true
            self.topLabel2.isHidden = true
            self.middleLabel1.isHidden = false
            self.middleLabel2.isHidden = false
            self.middleLabel3.isHidden = false
        }
    }

    func showLabels() {
        DispatchQueue.main.async {
            self.bottomLabel1.isHidden = false
            self.bottomLabel2.isHidden = false
            self.topLabel1.isHidden = false
            self.topLabel2.isHidden = false
            self.middleLabel1.isHidden = true
            self.middleLabel2.isHidden = true
            self.middleLabel3.isHidden = true
        }
    }
    
    func changeMiddeValue(yValue: Any,timeValue: Any) {
        let timestamp: TimeInterval = (timeValue as? TimeInterval)!
        let date = Date(timeIntervalSince1970: timestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = dateFormatter.string(from: date)
        
        self.middleLabel2.text = "\(yValue)"
        self.middleLabel3.text = "\(formattedDate)"
    }
}
