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
    var searchStock: Array<StockInfoSearch>?
    
    init() {
        currentStocks = Array<StockInfo>()
        searchStock = Array<StockInfoSearch>()
    }
    
    private enum URLAction {
        case Added (String)
        case Search(String)
    }
    
    private func generateURL(action: URLAction)->URL {
        searchStock?.removeAll()
        print("I'm in the generateURL")
        //User Searches with this URL: https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=BA&apikey=demo

        //User uses this API data: https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=MSFT&apikey=demo
        let baseURL = "https://www.alphavantage.co/query?"
        var urlComponents = URLComponents(string: baseURL)!
        var queryItemArrays=Array<URLQueryItem>()
        switch action {
        //After user searches, use the 'Added' API with the global quote
        case .Search(let searchTerm):
            queryItemArrays.append(URLQueryItem(
                name: "function",
                value: "SYMBOL_SEARCH"))
            queryItemArrays.append(URLQueryItem(
                name: "keywords",
                value: searchTerm))
        case .Added(let addTerm):
            queryItemArrays.append(URLQueryItem(name: "function", value: "GLOBAL_QUOTE"))
            queryItemArrays.append(URLQueryItem(name: "symbol", value: addTerm))
        }
        queryItemArrays.append(URLQueryItem(name: "apikey", value: GlobalConstants.APIKey.stockAPIKey))
        urlComponents.queryItems = queryItemArrays
        print(urlComponents.string!)
        return urlComponents.url!
        
    }
    
    //Search for stocks to add
    private func getStockSearch(url: URL, completionHandler: (()->())?) {
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) {
            (data, response, error) in
            if let actualError = error {print("I got an error: \(actualError)")}
            else if let _ = data {
                let parsedData = try? JSON(data: data!)
                for (_, aStock) in (parsedData?["bestMatches"])!{
                    print("Search Results: \(aStock)")
                    if let theSymbol = aStock["1. symbol"].string,
                        let theName = aStock["2. name"].string
                    {
                        let aStockSym = StockInfoSearch(
                            symbol: theSymbol,
                            name: theName)
                        self.searchStock?.append(aStockSym)
                    }
                }
            }
            DispatchQueue.main.async {
                completionHandler?()
            }
        } // End of Closure for session.dataTask()
        task.resume()

    }
    
    //Get stock data that already exists
    private func getStockData(url: URL, completionHandler: (()->())?) {
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) {
            (data, response, error) in
            if let actualError = error {print("I got an error: \(actualError)")}
            else if let _ = data {
                let parsedData = try? JSON(data: data!)
                for (_, aStock) in parsedData!{
                    print("Adding stock: \(aStock)")
                    if let theSymbol = aStock["01. symbol"].string,
                        let theOpen = aStock["02. open"].string,
                        let thePrice = aStock["05. price"].string,
                        let theChange = aStock["10. change percent"].string,
                        let theChangePr = aStock["09. change"].string
                    {
                        let aStockSym = StockInfo(
                            symbol: theSymbol,
                            open: theOpen,
                            price: thePrice,
                            changepc: theChange, change: theChangePr)
                        self.currentStocks?.append(aStockSym)
                    }
            }
        }
            DispatchQueue.main.async {
                completionHandler?()
            }
        }
        task.resume()
    }
    
    
    //Stocks that had already been added
    func getAdded(addTerm: String, completionHandler: (()->())? = nil) {
        // 1. generate a URL to get the data
        let theURL = generateURL(action: .Added(addTerm))
        getStockData(url: theURL, completionHandler: completionHandler)
    }
    
    //Search for stocks to add using the search bar
    func getStockSearch(searchTerm: String, completionHandler: (()->())? = nil) {
        // 1. generate a URL to get the data
        let theURL = generateURL(action: .Search(searchTerm))
        getStockSearch(url: theURL, completionHandler: completionHandler)
    }
    
    func getSearchCount()->Int {
        return searchStock!.count
    }
    func getStockCount()->Int {
        return currentStocks!.count
    }
    

    // MARK: internal methods
}
