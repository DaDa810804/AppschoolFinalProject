//
//  ThirdTableViewCell.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/28.
//

import UIKit
import Charts

class ThirdTableViewCell: UITableViewCell {
    
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "link")
        // 设置左侧图片视图的样式、内容等
        // ...
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USDT"
        // 设置上方标签的样式、内容等
        // ...
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "泰達幣"
        // 设置下方标签的样式、内容等
        // ...
        return label
    }()
    
    let chartView: LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置折线图视图的样式、内容等
        // ...
        return view
    }()
    
    let chartTopLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "30.58"
        // 设置折线图视图上方标签的样式、内容等
        // ...
        return label
    }()
    
    let chartBottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .green
        label.text = "+0.42%"
        // 设置折线图视图下方标签的样式、内容等
        // ...
        return label
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
        // 添加子视图到单元格的内容视图中
        contentView.addSubview(leftImageView)
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)
        contentView.addSubview(chartView)
        contentView.addSubview(chartTopLabel)
        contentView.addSubview(chartBottomLabel)
        
        // 添加约束
        NSLayoutConstraint.activate([
            // 左侧图片视图约束
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: 24),
            
            // 上方标签约束
            topLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -16),
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topLabel.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor, constant: -8),
            topLabel.heightAnchor.constraint(equalToConstant: 20), // 设置高度约束
            
            // 下方标签约束
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8),
            bottomLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16),
            bottomLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -16),
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            bottomLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // 折线图视图约束
            chartView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor,constant: -10),
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 72),
            chartView.widthAnchor.constraint(equalToConstant: 72),
            
            // 折线图视图上方标签约束
            chartTopLabel.leadingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 16),
            chartTopLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chartTopLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            chartTopLabel.heightAnchor.constraint(equalToConstant: 20),
            // 折线图视图下方标签约束
            chartBottomLabel.topAnchor.constraint(equalTo: chartTopLabel.bottomAnchor, constant: 8),
            chartBottomLabel.leadingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 16),
            chartBottomLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chartBottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            chartBottomLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        setChartView()
    }
    
    func setChartView() {
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        
        var values: [Double] = []
        var valueArray: [Double] = []
        for index in 1...30 {
            let randomValue = Double.random(in: 10...25)
            valueArray.append(randomValue)
        }
        var dataEntries: [ChartDataEntry] = []
        if valueArray.count >= 10 {
            while values.count < 10 {
                let randomIndex = Int.random(in: 0..<valueArray.count)
                let randomValue = valueArray [randomIndex]
                values.append(randomValue)
            }
        }
        for index in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(index), y: values[index])
            dataEntries.append(dataEntry)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries)
        dataSet.mode = .linear
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = 2.0
        dataSet.colors = [UIColor.green]
        let data = LineChartData (dataSet: dataSet)
        chartView.data = data
    }
}
    
