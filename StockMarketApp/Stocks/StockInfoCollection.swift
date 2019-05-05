//
//  StockInfoCollection.swift
//  StockMarketApp
//
//  Created by david on 5/4/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit

class StockInfoCollection {
    var currentStocks: Array<StockInfo>?
    
    func getStockAt(row: Int)->StockInfo? {
        return nil
    }
    
    private enum URLAction {
        case Search(String)
    }
    
    private func generateURL(action: URLAction)->URL {
        print("I'm in the generateURL")
        //https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=MSFT&apikey=demo
        let baseURL = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=MSFT&apikey=demo"
        var urlComponents = URLComponents(string: baseURL)!
        //var queryItemArrays=Array<URLQueryItem>()
        /*switch action {
        case .Search(let searchTerm):
            queryItemArrays.append(URLQueryItem(
                name: "function",
                value: "GLOBAL_QUOTE"))
            queryItemArrays.append(URLQueryItem(
                name: "symbol",
                value: searchTerm))
        }*/
        
        //queryItemArrays.append(URLQueryItem(name: "apikey", value: GlobalConstants.APIKey.stockAPIKey))
        //urlComponents.queryItems = queryItemArrays
        print(urlComponents.string!)
        return urlComponents.url!
        
    }
    
    private func getStockData(url: URL, completionHandler: (()->())?) {
        // 2. retrieve the data
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) {
            // completion handler using trailing closure syntax
            (data, response, error) in
            var localStocks = Array<StockInfo>()
            // write some code here
            print("I'm in \(#file) at line \(#line)")
            if let actualError = error {
                print("I got an error: \(actualError)")
            } else if let actualResponse = response,
                let actualData = data,
                let parsedData = try? JSON(data: actualData) {
                print("I got some data: \(actualData)")
                
                //print("I got some data: \(parsedData)")
                let theStocks = parsedData["stocks"]
                let theRealStocks = theStocks["stock"]
                for (_, aStock) in theRealStocks{
                    print("I got a stock: \(aStock)")
                    if let theURLS = aStock["urlS"].url,
                        let theSymbol = aStock["symbol"].string,
                        let theOpen = aStock["open"].double
                    {
                        // 3. parse the data: Convert JSON to a usable structure
                        // let parsedData = try? JSON(data: ???)
                        // 4. fill my array of FlickPictures with the data from (3)
                        var aStockSym = StockInfo(
                            symbol: theSymbol,
                            open: theOpen,
                            urlS: theURLS
                        )
                        localStocks.append(aStockSym)
                    }
                }
                // print("I got some data: \(theRealPhotos)")
                self.currentStocks = localStocks
            }
            print("Done with Closure. \(localStocks.count) rows")
            // If there is a completionHandler, dispatch it to the main thread
            DispatchQueue.main.async {
                completionHandler?()
            }
        } // End of Closure for session.dataTask()
        // the task is created stopped. We need to start it.
        print("I'm in \(#file) at line \(#line)")
        task.resume()
        print("I'm in \(#file) at line \(#line)")
        // conditional unwrap
    }
    
    // This method will fill currentPhotos with photos related to search term
    func getWith(searchTerm: String, completionHandler: (()->())? = nil) {
        currentStocks = Array<StockInfo>()
        // 1. generate a URL to get the data
        let theURL = generateURL(action: .Search(searchTerm))
        getStockData(url: theURL, completionHandler: completionHandler)
    }
    
    func getStockCount()->Int {
        return currentStocks?.count ?? 0
    }
    
    init(){
        
    }
    deinit {

    }
    // MARK: internal methods
}
