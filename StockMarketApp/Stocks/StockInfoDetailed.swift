//
//  StockInfoDetailed.swift
//  StockMarketApp
//
//  Created by david on 5/6/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit

class StockInfoDetailed {
     var myClose: String
     var myVolume: String
     var myLow: String
     var myOpen: String
     var myHigh: String
     var myTime: String
    
    func getLow() -> Double{
        let num = Double(myLow)
        return num!
    }
    
    func getHigh() -> Double{
        let num = Double(myHigh)
        return num!
    }
    
    func getOpen() -> Double{
        let num = Double(myOpen)
        return num!
    }
    
    func getClose() -> Double{
        let num = Double(myClose)
        return num!
    }
    
    func getTime() -> Double {
        let num = myTime.dropFirst(11)
        let numb = Double(num.replacingOccurrences(of: ":", with: ""))
        
        return numb!
    }

    init(
     myTime: String,
     myOpen: String,
     myHigh: String,
     myLow: String,
     myClose: String,
     myVolume: String) {
        self.myClose = myClose
        self.myVolume = myVolume
        self.myLow = myLow
        self.myOpen = myOpen
        self.myHigh = myHigh
        self.myTime = myTime
    }
}
