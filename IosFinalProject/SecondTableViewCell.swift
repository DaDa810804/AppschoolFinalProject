//
//  SecondTableViewCell.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/28.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "市場"
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = ""
        return label
    }()
    
    let label3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "幣別"
        return label
    }()
    
    let label4: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "1天"
        return label
    }()
    
    let label5: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "NT$ / 24H"
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.addSubview(label1)
        containerView.addSubview(label2)
        containerView.addSubview(label3)
        containerView.addSubview(label4)
        containerView.addSubview(label5)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label1.topAnchor.constraint(equalTo: containerView.topAnchor),
            label1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 16),
            label1.trailingAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            label2.topAnchor.constraint(equalTo: containerView.topAnchor),
            label2.leadingAnchor.constraint(equalTo: containerView.centerXAnchor),
            label2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            label3.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            label3.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 16),
            label3.trailingAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            label4.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            label4.leadingAnchor.constraint(equalTo: containerView.centerXAnchor),
            label4.trailingAnchor.constraint(equalTo: label5.leadingAnchor),
            
            label5.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            label5.leadingAnchor.constraint(equalTo: label4.trailingAnchor),
            label5.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
            label5.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -16)
        ])
    }
}
