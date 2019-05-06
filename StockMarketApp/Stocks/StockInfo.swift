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
    var price: String
    var changepc: String
    var change: String

    func getSymbol()->String{
        print("Returning Symbol\(symbol)")
        return "$" + symbol
    }
    func getOpen()->String{
        let setOpen = Double(open)
        
        return String(format: "$%.02f", setOpen!)    }
    
    func getPrice()->String{
        print("Returning Price\(price)")
        let setPrice = Double(price)
        
        return String(format: "$%.02f", setPrice!)
    }
    
    func getChangePC()->String{
        var pieces = Double(changepc.dropLast())
        
        return String(format: "%.03f%%", pieces!)
    }
 
    func getChange()->String{
        let setChange = Double(change)
        
        return String(format: "$%.03f", setChange!)    }
    
    init(symbol:String,
         open: String,
        price: String,
        changepc: String,
        change: String) {
        self.symbol = symbol
        self.open = open
        self.price = price
        self.changepc = changepc
        self.change = change
    }
}


