//
//  ChartsTableViewCell.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/30.
//

import UIKit
import Charts

class ChartsTableViewCell: UITableViewCell {
    var getPriceCell: (() -> (PriceTableViewCell))!
    var isValueSelected = false
    var data: LineChartData!
    var selectedCurrency: String?
    var minXIndex: Double!
    var maxXIndex: Double!
    var dataSet: LineChartDataSet!
    var rightDataArray: [Double] = []
    var dayArray:[Double] = []
    var dataEntries: [ChartDataEntry] = []

    
    
    let stackView = UIStackView()
    let buttonTitles = ["1D", "1W", "1M", "3M", "1Y", "All"]
    var lineChartView: LineChartView!
    var indicatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLineChartView()
        setupButtons()
        setupIndicatorView()
//        setChartView(dataArray: rightDataArray)
        lineChartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 20)
//        updateViews()
    }

    func setupLineChartView() {
        lineChartView = LineChartView()
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        // 设置折线图视图的样式、内容等
        // ...
        contentView.addSubview(lineChartView)
        lineChartView.delegate = self
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineChartView.heightAnchor.constraint(equalTo: lineChartView.widthAnchor)
        ])
    }
    
    func setupButtons() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.tag = index // 设置按钮的tag为索引值
            stackView.addArrangedSubview(button)
        }
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stackView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func setupIndicatorView() {
        indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.backgroundColor = .red
        
        stackView.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.widthAnchor.constraint(equalTo: stackView.arrangedSubviews[0].widthAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 4),
            indicatorView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        
        // 將指示線設置在選中的按鈕位置
        if let selectedButton = stackView.arrangedSubviews.first as? UIButton {
            selectedButton.setTitleColor(.red, for: .normal)
            indicatorView.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor).isActive = true
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        updateIndicatorPosition(for: index)
        if index == 0 {
            ApiManager.shared.fetchCandleData(productID: selectedCurrency!, timeRange: TimeRange.oneDay) {
                candles, error in
                if candles?.isEmpty == false {
                    var dayArray: [Double] = [] ; var chartsArray: [Double] = []
                    for index in candles! {
                        dayArray.append(index.time)
                        chartsArray.append((index.high + index.low) / 2)
                    }
                    DispatchQueue.main.async {
                        self.dayArray = dayArray.reversed()
                        self.changeChartViewData(dataArray: chartsArray.reversed())
                    }
                } else {
                    DispatchQueue.main.async {
                        self.changeChartViewData(dataArray: [0,0])
                    }
                }
            }
        } else if index == 1 {
            ApiManager.shared.fetchCandleData(productID: selectedCurrency!, timeRange: TimeRange.oneWeek) {
                candles, error in
                var chartsArray: [Double] = []
                var dayArray: [Double] = []
                for index in candles! {
                    dayArray.append(index.time)
                    chartsArray.append((index.high + index.low) / 2)
                }
                DispatchQueue.main.async {
                    self.dayArray = dayArray.reversed()
                    self.changeChartViewData(dataArray: chartsArray.reversed())
                }
            }
        } else if index == 2 {
            ApiManager.shared.fetchCandleData(productID: selectedCurrency!, timeRange: TimeRange.oneMonth) {
                candles, error in
                var chartsArray: [Double] = []
                var dayArray: [Double] = []
                for index in candles! {
                    dayArray.append(index.time)
                    chartsArray.append((index.high + index.low) / 2)
                }
                DispatchQueue.main.async {
                    self.dayArray = dayArray.reversed()
                    self.changeChartViewData(dataArray: chartsArray.reversed())
                }
            }
        } else if index == 3 {
            ApiManager.shared.fetchCandleData(productID: selectedCurrency!, timeRange: TimeRange.threeMonths) {
                candles, error in
                var chartsArray: [Double] = []
                var dayArray: [Double] = []
                for index in candles! {
                    dayArray.append(index.time)
                    chartsArray.append((index.high + index.low) / 2)
                }
                DispatchQueue.main.async {
                    self.dayArray = dayArray.reversed()
                    self.changeChartViewData(dataArray: chartsArray.reversed())
                }
            }
        } else if index == 4 {
            ApiManager.shared.fetchCandleYearData(productID: selectedCurrency!, timeRange: TimeRange.oneYear) {
                candles, error in
                var chartsArray: [Double] = []
                var dayArray: [Double] = []
                for index in candles! {
                    dayArray.append(index.time)
                    chartsArray.append((index.high + index.low) / 2)
                }
                DispatchQueue.main.async {
                    self.dayArray = dayArray
                    self.changeChartViewData(dataArray: chartsArray)
                }
            }
        } else if index == 5 {
            ApiManager.shared.fetchAllCandleData(productID: selectedCurrency!) { candles, error in
                var chartsArray: [Double] = []
                var dayArray: [Double] = []
                for index in candles! {
                    dayArray.append(index.time)
                    chartsArray.append((index.high + index.low) / 2)
                }
                DispatchQueue.main.async {
                    self.dayArray = dayArray.reversed()
                    self.changeChartViewData(dataArray: chartsArray.reversed())
                }
            }
        }
        for (buttonIndex, button) in stackView.arrangedSubviews.enumerated() {
            if let button = button as? UIButton {
                if buttonIndex == index {
                    button.setTitleColor(.red, for: .normal) // 点击状态下字体为红色
                } else {
                    button.setTitleColor(.gray, for: .normal) // 非点击状态下字体为灰色
                }
            }
        }
    }
    
    func updateIndicatorPosition(for index: Int) {
        guard let selectedButton = stackView.arrangedSubviews[index] as? UIButton else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.frame.origin.x = selectedButton.frame.origin.x
            self.layoutIfNeeded()
        }
    }
}

extension ChartsTableViewCell: ChartViewDelegate {
    
    func changeChartViewData(dataArray: [Double]) {
        lineChartView.data = nil
        lineChartView.xAxis.valueFormatter = nil
        lineChartView.marker = nil
        lineChartView.notifyDataSetChanged()
        minXIndex = Double(dataArray.firstIndex(of: dataArray.min()!)!) + 1
        maxXIndex = Double(dataArray.firstIndex(of: dataArray.max()!)!) + 1
        dataEntries = []
        dataSet = nil
        for index in 0..<dataArray.count {
                    let formattedValue = String(format: "%.2f", dataArray[index])
                    let dataEntry = ChartDataEntry(x: Double(index+1), y: Double(formattedValue) ?? 0)
                    dataEntries.append(dataEntry)
        }

//        lineChartView.xAxis.valueFormatter =

        dataSet = LineChartDataSet(entries: dataEntries)
        dataSet.mode = .linear
        dataSet.drawCirclesEnabled = false
        dataSet.valueFormatter = self
        dataSet.highlightLineWidth = 1.5
        dataSet.highlightColor = .red
        dataSet.highlightEnabled = true
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.lineWidth = 1.5
        dataSet.colors = [UIColor.red]
        dataSet.valueColors = [UIColor.red]
        dataSet.valueFont = .systemFont(ofSize: 12)
        data = LineChartData(dataSet: dataSet)
        lineChartView.data = data


        if let data = lineChartView.data {
            if let lineDataSet = data.dataSets.first as? LineChartDataSet {
                let startColor = UIColor.red
                let endColor = UIColor.white
                let gradientColors = [startColor.cgColor, endColor.cgColor] as CFArray
                let colorLocations: [CGFloat] = [0.0, 1.0]
                if let gradient = CGGradient(colorsSpace: nil, colors: gradientColors, locations: colorLocations) {
                    lineDataSet.fill = LinearGradientFill(gradient: gradient, angle: 270)
                    lineDataSet.drawFilledEnabled = true
                }
            }
        }

        if let selectedEntry = dataEntries.first {

            let coinImage = UIImage(named: "fulldown")
            let coinMarker = ImageMarkerView(color: .clear, font: .systemFont(ofSize: 10), textColor: .white, insets: .zero, image: coinImage)
            coinMarker.refreshContent(entry: selectedEntry, highlight: Highlight(x: selectedEntry.x, y: selectedEntry.y, dataSetIndex: 0))
            lineChartView.marker = coinMarker
        }

        lineChartView.notifyDataSetChanged()
    }
    
    func setChartView(dataArray: [Double]) {
        lineChartView.delegate = self
        lineChartView.chartDescription.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
//        lineChartView.xAxis.valueFormatter = XAxisValueFormatter(monthlyTotalAmounts: monthlyTotalAmounts)
        // 設定折線圖的數據
//        changeChartViewData(dataArray: allTestArray.last!)
        changeChartViewData(dataArray: dataArray)
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        guard let lineChartView = chartView as? LineChartView else {
            return
        }
        isValueSelected = false
        updateViews()
        print("本來顯示的兩個label要出見")
//        historyAverageView.isHidden = true
        lineChartView.data?.dataSets.forEach { dataSet in
            if let lineChartDataSet = dataSet as? LineChartDataSet {
                lineChartView.highlightValues([])
            }
        }
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("要讓我的畫面上變成只有一個label來顯示使用者點選到的價錢\(entry.y)")
        isValueSelected = true
        updateViews()
        let timeIndex = Int(entry.x) - 1
        let time = dayArray[timeIndex]
        getPriceCell().changeMiddeValue(yValue: entry.y,timeValue: time)
    }
    
    private func updateViews() {
        if isValueSelected {
            getPriceCell().hideLabels()
            // 隐藏 priceTableViewCell 中的文字
            // 设置 priceTableViewCell 的文字隐藏属性为 true
        } else {
            getPriceCell().showLabels()
            // 显示 priceTableViewCell 中的文字
            // 设置 priceTableViewCell 的文字隐藏属性为 false
        }
    }

}
extension ChartsTableViewCell: ValueFormatter {
    
    func stringForValue(_ value: Double, entry: Charts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: Charts.ViewPortHandler?) -> String {
        if entry.x == minXIndex || entry.x == maxXIndex {
            entry.icon = UIImage(named: "down")
            
            return "\(value)"
        } else {
            return ""
        }
    }

}
