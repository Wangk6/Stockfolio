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
    var open: Double
    var price: Double
    var changepc: Double
    
    func getSymbol()->String{
        return symbol
    }
    func getOpen()->Double{
        return open
    }
    
    func getPrice()->Double{
        return price
    }
    
    func getChangePC()->Double{
        return changepc
    }
    
    
    init(symbol:String,
         open: Double,
        price: Double,
        changepc: Double) {
        self.symbol = symbol
        self.open = open
        self.price = price
        self.changepc = changepc
    }
}


