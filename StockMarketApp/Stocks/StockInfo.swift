//
//  StockInfo.swift
//  StockMarketApp
//
//  Created by david on 5/3/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import Foundation

class StockInfo {
    var symbol: String
    var open: Double
    var high: Double
    var low: Double
    var price: Double
    var volume: Int
    var lastTradingDay: Date
    var prevClosePrice: Double
    var change: Double
    var changePercent: Double
    
    init(symbol:String,
         open: Double,
         high: Double,
         low: Double,
         price: Double,
         volume: Int,
         lastTradingDay: Date,
         prevClosePrice: Double,
         change: Double,
         changePercent: Double) {
        self.symbol = symbol
        self.open = open
        self.high = high
        self.low = low
        self.price = price
        self.volume = volume
        self.lastTradingDay = lastTradingDay
        self.prevClosePrice = prevClosePrice
        self.change = change
        self.changePercent = changePercent
    }
}
