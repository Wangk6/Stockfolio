//
//  StockMarketAppTests.swift
//  StockMarketAppTests
//
//  Created by david on 5/3/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import XCTest
@testable import StockMarketApp

class StockMarketAppTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let myModel = StockInfoCollection()
        myModel.getAdded(addTerm: "X")
        XCTAssert(myModel.getStockCount() == 0) //Not actually added,
        myModel.getSearch(searchTerm: "X")
        XCTAssert(myModel.getSearchCount() == 0) //Not actually added
        let myInfo = StockInfo(symbol: "X", open: "10", high: "10", low: "10", price: "10", volume: "10", changepc: "10", change: "10")
        XCTAssertNotNil(myInfo.price, "10")
        XCTAssertNotNil(myInfo.open, "10")
        XCTAssertNotNil(myInfo.high, "10")
        XCTAssertNotNil(myInfo.low, "10")
        let changePc = myInfo.getChangePC()
        XCTAssertEqual(changePc, "1.000%") //3 dec+ %
        let changeN = myInfo.getChange()
        XCTAssertEqual(changeN, "$10.00") //$ + 2 dec
        let myDetail = StockInfoDetailed(myTime: "10", myOpen: "100", myHigh: "1000", myLow: "10000", myClose: "100000", myVolume: "100")
        XCTAssertEqual(myDetail.getClose(), 100000.0)//Double
        
        

        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
