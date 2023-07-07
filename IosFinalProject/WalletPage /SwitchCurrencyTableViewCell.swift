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
        imageView.image = UIImage(named: "all")
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
    
    func configure(with coinCode: String) {
        getIconImage(for: coinCode) { image in
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
    }
    
    private func getIconImage(for coinCode: String, completion: @escaping (UIImage?) -> Void) {
        let lowercased = coinCode.lowercased()
        let coinIconUrl = "https://cryptoicons.org/api/black/\(lowercased)/200"
        guard let url = URL(string: coinIconUrl) else { return }
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            completion(image)
        } else {
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                if let image = UIImage(data: data) {
                    let cachedResponse = CachedURLResponse(response: response!, data: data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
}
