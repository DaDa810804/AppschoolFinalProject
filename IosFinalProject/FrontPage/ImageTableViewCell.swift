//
////  ImageTableViewCell.swift
////  IosFinalProject
////
////  Created by 蔡顯達 on 2023/6/28.

import UIKit
import iCarousel

class ImageTableViewCell: UITableViewCell {

    var imageArrayTest = ["image31","image32","image33","image34"]
    var pageControl: UIPageControl!
    var icrview: iCarousel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    }
    func setupICarouselView() {
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
        // 创建页面控制器
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        
        icrview = {
            let view = iCarousel(frame: CGRect(x: 0, y: 0, width: 360, height: 200))
            view.translatesAutoresizingMaskIntoConstraints = false
            view.delegate = self
            view.dataSource = self
            view.type = .linear
            view.isPagingEnabled = true
            return view
        }()
        contentView.addSubview(icrview)
        pageControl.numberOfPages = icrview.numberOfItems
        pageControl.currentPage = 0
        icrview.addSubview(pageControl)

        // 添加约束
        NSLayoutConstraint.activate([
            pageControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            icrview.topAnchor.constraint(equalTo: contentView.topAnchor),
            icrview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            icrview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            icrview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            icrview.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func changeBanner() {
        icrview.scrollToItem(at: icrview.currentItemIndex + 1, animated: true)
    }
    
    func getWebsiteURL(for index: Int) -> URL? {
        // 根据索引返回相应的网站链接
        // 示例：假设 imageArray 和 websiteURLs 数组是一一对应的
        let websiteURLs = [
            URL(string: "https://zh.wikipedia.org/zh-tw/%E4%BB%A5%E5%A4%AA%E5%9D%8A")!,
            URL(string: "https://zh.wikipedia.org/zh-tw/%E6%AF%94%E7%89%B9%E5%B8%81")!,
            URL(string: "https://coinmarketcap.com/zh-tw/currencies/solana/")!,
            URL(string: "https://ethereum.org/zh-tw/")!
        ]
        
        guard index >= 0 && index < websiteURLs.count else { return nil }
        return websiteURLs[index]
    }

}


extension ImageTableViewCell: iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return imageArrayTest.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let itemImageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: UIScreen.main.bounds.width,
                                                      height: carousel.bounds.height))
        itemImageView.image = UIImage(named: "\(imageArrayTest[index])")
        return itemImageView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .wrap {
            return 1
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let websiteURL = getWebsiteURL(for: index)
        if let url = websiteURL {
            // 检查设备是否可以打开指定的URL
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("无法打开URL: \(url)")
            }
        }
    }
}
