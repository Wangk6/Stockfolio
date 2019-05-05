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
    var urlS: URL
    
    
    func getSymbol()->String{
        return symbol
    }
    func getOpen()->Double{
        return open
    }
    
    init(symbol:String,
         open: Double,
         urlS: URL) {
        self.symbol = symbol
        self.open = open
        self.urlS = urlS
    }
}


