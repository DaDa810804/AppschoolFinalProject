//
//  ProfileViewController.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/6.
//

import UIKit

class ProfileViewController: UIViewController {

    let navigationItemleftButton: UIBarButtonItem = {
        let leftButton = UIBarButtonItem(title: "我的", style: .plain, target: nil, action: nil)
        let disabledColor = UIColor.white
        let disabledFont = UIFont.systemFont(ofSize: 20)
        leftButton.setTitleTextAttributes([.foregroundColor: disabledColor, .font: disabledFont], for: .disabled)
        leftButton.isEnabled = false
        return leftButton
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "David"
        label.font = UIFont.systemFont(ofSize: 18,weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let uidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "UID: 123123123"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let rightLabelView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 6
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.white.cgColor
        container.backgroundColor = UIColor.white
        
        container.layer.shadowColor = UIColor.gray.cgColor
        container.layer.shadowOpacity = 0.9
        container.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        container.layer.shadowRadius = 2.0
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "身份驗證成功"
        label.textAlignment = .center
        label.textColor = .myGreen
        label.font = UIFont.systemFont(ofSize: 14,weight: .bold)
        
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .black
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    let accountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "帳戶管理"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        // 设置上方标签的样式、内容等
        // ...
        return label
    }()
    
    let accountRightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let signOutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        imageView.tintColor = .black
        // 设置左侧图片视图的样式、内容等
        // ...
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    let signOutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "登出"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        // 设置上方标签的样式、内容等
        // ...
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.leftBarButtonItem = navigationItemleftButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedProfileData = UserDefaults.standard.data(forKey: "UserProfile"),
           let savedProfile = try? JSONDecoder().decode([Profile].self, from: savedProfileData) {
            // 使用 UserDefaults 中的資料更新畫面
            self.uidLabel.text = savedProfile.first?.userId
            self.nameLabel.text = savedProfile.first?.name
        } else {
            // 從 API 取得使用者資料
            ApiManager.shared.getUserProfile { [weak self] profile in
                DispatchQueue.main.async {
                    self?.uidLabel.text = profile.first?.userId
                    self?.nameLabel.text = profile.first?.name
                    
                    // 將使用者資料存入 UserDefaults
                    if let profileData = try? JSONEncoder().encode(profile) {
                        UserDefaults.standard.set(profileData, forKey: "UserProfile")
                    }
                }
            }
        }
    }
    
    func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(uidLabel)
        view.addSubview(rightLabelView)
        view.addSubview(iconImageView)
        view.addSubview(accountLabel)
        view.addSubview(accountRightButton)
        view.addSubview(separatorView)
        view.addSubview(signOutImageView)
        view.addSubview(signOutLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            uidLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            uidLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            rightLabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            rightLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            iconImageView.topAnchor.constraint(equalTo: uidLabel.bottomAnchor, constant: 48),
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            accountLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            accountLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            accountRightButton.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            accountRightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 32),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            signOutImageView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 32),
            signOutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            signOutLabel.leadingAnchor.constraint(equalTo: signOutImageView.trailingAnchor, constant: 16),
            signOutLabel.centerYAnchor.constraint(equalTo: signOutImageView.centerYAnchor)
        ])
    }
}
