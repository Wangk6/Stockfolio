//
//  StockInfoSearch.swift
//  StockMarketApp
//
//  Created by david on 5/5/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit

class StockInfoSearch{
    var symbol:String
    var name: String

func getSymbol()->String{
        return "$"+symbol
}
func getName()->String{
    return name
}
    
    init(symbol:String,
         name: String) {
        self.symbol = symbol
        self.name = name
    }
}
