//
//  StockInfo.swift
//  StockMarketApp
//
//  Created by david on 5/3/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit

class StockInfo {
    var symbol: String
    var open: String
    var high: String
    var low: String
    var price: String
    var volume: String
    var changepc: String
    var change: String

    func getSymbol()->String{
        print("Returning Symbol\(symbol)")
        return "$" + symbol
    }
    func getOpen()->String{
        let setOpen = Double(open)
        return String(format: "$%.02f", setOpen!)
    }
    func getHigh()->String{
        let setHigh = Double(high)
        return String(format: "$%.02f", setHigh!)
    }
    func getLow()->String{
        let setLow = Double(low)
        return String(format: "$%.02f", setLow!)
    }
    func getPrice()->String{
        print("Returning Price\(price)")
        let setPrice = Double(price)
        
        return String(format: "$%.02f", setPrice!)
    }
    func getVolume()->String{
        return volume
    }
    
    func getChangePC()->String{
        let pieces = Double(changepc.dropLast())
        
        return String(format: "%.03f%%", pieces!)
    }
 
    func getChange()->String{
        let setChange = Double(change)
        
        return String(format: "$%.02f", setChange!)    }
    
    init(symbol:String,
         open: String,
         high: String,
         low: String,
        price: String,
        volume: String,
        changepc: String,
        change: String) {
        self.symbol = symbol
        self.open = open
        self.high = high
        self.low = low
        self.price = price
        self.volume = volume
        self.changepc = changepc
        self.change = change
    }
}


