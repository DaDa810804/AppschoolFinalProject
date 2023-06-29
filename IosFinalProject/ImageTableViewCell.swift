//
////  ImageTableViewCell.swift
////  IosFinalProject
////
////  Created by 蔡顯達 on 2023/6/28.

import UIKit

class ImageTableViewCell: UITableViewCell {
    let width = UIScreen.main.bounds.width
    var pageControl: UIPageControl!
    let imageArray: [UIImage] =
    {
        var array = [UIImage]()
        for index in 31...34
        {
            let imageName = "image" + String(index)
            if let image = UIImage(named: imageName) {
                array.append(image)
            }
        }
        array.append(UIImage(named: "image31")!)
        return array
    }()
    
    //儲存當下顯示的圖片的索引
    var imageIndex = 0
    
    //宣告一個CollectionView
    var collectionView: UICollectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        collectionView.frame = contentView.bounds
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: bounds.width,
                                 height: 200)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        
        contentView.addSubview(collectionView)
        
        
        // 创建页面控制器
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = imageArray.count - 1
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        

        // 将页面控制器添加到 contentView 中
        contentView.addSubview(pageControl)

        // 添加约束
        NSLayoutConstraint.activate([
            pageControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 20)
        ])
        // 添加约束
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
        // 添加手势识别器
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    @objc func changeBanner() {
        imageIndex += 1
        let indexPath: IndexPath = IndexPath(item: imageIndex, section: 0)
        if imageIndex == imageArray.count {
            print("Scroll to zero")
            imageIndex = 0
            collectionView.scrollToItem(at: IndexPath(item: imageIndex, section: 0), at: .centeredHorizontally, animated: false)
            changeBanner()
        } else if imageIndex < imageArray.count {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            if imageIndex == 4 {
                pageControl.currentPage = 0
            } else {
                pageControl.currentPage = imageIndex
            }
        }
    }
    
    
    @objc func handleImageTap(_ gesture: UITapGestureRecognizer) {
        guard let collectionView = gesture.view as? UICollectionView else { return }
        let location = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            // 根据索引获取相应的网站链接
            let websiteURL = getWebsiteURL(for: indexPath.item)
            print(websiteURL)
            if let url = websiteURL {
                // 检查设备是否可以打开指定的URL
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("无法打开URL: \(url)")
                }
            }
            // 在此处执行跳转到网站的操作，例如使用 SafariViewController 或打开 Safari 浏览器
            // 根据需要进行相应的实现
            // ...
        }
    }
    
    func getWebsiteURL(for index: Int) -> URL? {
        // 根据索引返回相应的网站链接
        // 示例：假设 imageArray 和 websiteURLs 数组是一一对应的
        let websiteURLs = [
            URL(string: "https://zh.wikipedia.org/zh-tw/%E4%BB%A5%E5%A4%AA%E5%9D%8A")!,
            URL(string: "https://zh.wikipedia.org/zh-tw/%E6%AF%94%E7%89%B9%E5%B8%81")!,
            URL(string: "https://coinmarketcap.com/zh-tw/currencies/solana/")!,
            URL(string: "https://ethereum.org/zh-tw/")!,
            URL(string: "https://zh.wikipedia.org/zh-tw/%E4%BB%A5%E5%A4%AA%E5%9D%8A")!
        ]
        
        guard index >= 0 && index < websiteURLs.count else { return nil }
        return websiteURLs[index]
    }

}

extension ImageTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCollectionViewCell
        cell?.imageView.image = imageArray[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        if let currentIndexPath = visibleIndexPaths.first {
            if currentIndexPath.item == 4 {
                pageControl.currentPage = 0
            } else {
                pageControl.currentPage = currentIndexPath.item
            }
            
        }
    }
}
