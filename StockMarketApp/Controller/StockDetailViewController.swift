//
//  StockDetailViewController.swift
//  StockMarketApp
//
//  Created by david on 5/6/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit
import Charts

class StockDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let dataSource = ["1min", "5min", "15min", "30min", "60min"]
    var myStock: StockInfo?
    var myModel = StockInfoCollection()
    var myDetail: StockInfoDetailed?
    
    //Data for chart
    var chartInfo = CandleChartDataEntry()
    
    @IBOutlet weak var stockChart: CandleStickChartView!
    @IBOutlet weak var intBtn: UIButton!
    
    @IBOutlet weak var myPrice: UILabel?
    @IBOutlet weak var myPercent: UILabel?
    @IBOutlet weak var myVolume: UILabel?
    @IBOutlet weak var myLow: UILabel?
    @IBOutlet weak var myChange: UILabel?
    @IBOutlet weak var myOpen: UILabel?
    @IBOutlet weak var myHigh: UILabel?
    @IBOutlet weak var intervalPicer: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPrice?.text = myStock!.getPrice()
        myPercent?.text = myStock!.getChangePC()
        myVolume?.text = myStock!.getVolume()
        myLow?.text = myStock!.getLow()
        myHigh?.text = myStock!.getHigh()
        myChange?.text = myStock!.getChange()
        myOpen?.text = myStock!.getOpen()
        intervalPicer.dataSource = self
        intervalPicer.delegate = self
        intervalPicer.isHidden = true
        intervalPicer.backgroundColor = UIColor.gray
        intervalPicer.layer.borderColor = UIColor.white.cgColor
        intervalPicer.layer.borderWidth = 1
        intervalPicer.setValue(UIColor.white, forKeyPath: "textColor")
        //intervalPicer.tintColor = UIColor.gray

        if myStock?.getChangePC().first == "-"{
            myPercent!.textColor = UIColor.red
            myPercent!.textColor = UIColor.red
        } else {
            myPercent!.textColor = UIColor.green
            myPercent!.textColor = UIColor.green
        }
        
        //////Detail Chart
        self.navigationItem.title = myStock!.getSymbol()
        stockChart.noDataText = ""
        getChartData(interval: "1min")
    }

    @IBAction func intervalBtn(_ sender: Any) {
        if(intervalPicer.isHidden == false){
            intervalPicer.isHidden = true
        }else if(intervalPicer.isHidden == true){
            intervalPicer.isHidden = false
        }
    }
    
    func setChartData(){
        let sortedDictionary = myModel.detailStock!.sorted{$0.key<$1.key}
        
        var priceEntries = [ChartDataEntry]()
        var times: [String] = []
        var barColors: [UIColor] = []
        var i = 0.0
        for price in sortedDictionary {
            // Create single chart data entry and append it to the array
            let priceEntry = CandleChartDataEntry(x: i, shadowH: price.value.getHigh(), shadowL: price.value.getLow(), open: price.value.getOpen(), close: price.value.getClose())
            priceEntries.append(priceEntry)
            i+=1.0
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .none
            barColors.append(graphColor(close: price.value.getClose(), open: price.value.getOpen()))
            times.append("\(dateFormatter.string(from: Date.init(timeIntervalSince1970: TimeInterval("1")!)))")
        }
        
        let chartDataSet = CandleChartDataSet(entries: priceEntries, label: "Test")
        let chartData = CandleChartData(dataSets: [chartDataSet])
        //self.stockChart.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
          //  return times[Int(index)]
        //})
        self.stockChart.xAxis.setLabelCount(times.count, force: true)
    
        print("Setting chart data")
        stockChart.data = chartData
        stockChart.legend.enabled = false
        stockChart.leftAxis.enabled = false
        stockChart.rightAxis.labelTextColor = UIColor.white
        stockChart.xAxis.enabled = false
        chartDataSet.drawValuesEnabled = false
        stockChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        
        chartDataSet.colors = barColors
        
        stockChart.backgroundColor = UIColor.black
        stockChart.borderColor = UIColor.lightGray
        stockChart.gridBackgroundColor = UIColor.white
    }
    func graphColor(close: Double, open: Double)->UIColor{
        if (close < open){
            return UIColor.red
        } else if (close == open){
            return UIColor.gray
        } else {
            return UIColor.green
        }
    }
    
    func getChartData(interval: String){
        let symbol = myStock!.getSymbol()
        let removeDollar = symbol.dropFirst()
        myModel.getDetail(addDetail: String(removeDollar), addInterval: interval){
        self.setChartData()
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getChartData(interval: dataSource[row])
        intBtn.setTitle("1Day:"+dataSource[row], for: .normal)
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
}

