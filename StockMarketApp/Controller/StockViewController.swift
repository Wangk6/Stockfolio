//
//  StockViewController.swift
//  StockMarketApp
//
//  Created by david on 5/6/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit

class StockViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var searchStocks = StockInfoCollection()
    var myModel = StockInfoCollection()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    
    var searchBar: UISearchBar!
    var searchAddStock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.rowHeight = 80.0
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Stocks"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath)
        let row = indexPath.row
        if let actualCell = cell as? StockTableViewCell
            {
            // reload
            
            if isFiltering(){
                print("I'm in cellForRow filtering")
                actualCell.stockName.text = ""
                actualCell.stockLastPrice.text = ""
                actualCell.changeP.text = ""
                actualCell.change.text = ""
                titleLabel1.text = "Stock Name"
                titleLabel2.text = ""
                titleLabel3.text = "Symbol"
                let search = (searchStocks.searchStock?[row])
                actualCell.stockFullName.text = search?.name
                actualCell.stockFullName.adjustsFontSizeToFitWidth.toggle()
                actualCell.stockSymbol.text = search?.symbol
                print("Adding search cell")
                self.tableView.reloadRows(
                    at: [indexPath],
                    with: .automatic)
            }else{
                print("I'm in cellForRow not filtering")
                let theStock = myModel.currentStocks?[row]
                //Remove the search words
                actualCell.stockFullName.text = ""
                actualCell.stockFullName.adjustsFontSizeToFitWidth.toggle()
                actualCell.stockSymbol.text = ""
                //Add stock 
                actualCell.stockName.text = theStock?.getSymbol()
                actualCell.stockLastPrice.text = theStock?.getPrice()
                actualCell.changeP.text = theStock?.getChangePC()
                actualCell.change.text = theStock?.getChange()
                print("Adding actual cell")
                self.tableView.reloadRows(
                    at: [indexPath],
                    with: .automatic)
            }
        }
        if(searchAddStock == true){
        self.tableView.reloadData()
        searchAddStock = false
        return cell
        } else {return cell}
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("My stock count\(myModel.getStockCount())")
        print("My search count\(searchStocks.searchStock())")

        if isFiltering() {
            return (searchStocks.searchStock?.count)!
        }
        
        return (myModel.currentStocks?.count)!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searchBarIsEmpty() == true) {
            print("Added row selected")
        }
        else if(searchController.isActive == true){
            let search = (searchStocks.searchStock?[indexPath.row])
            let symbol = search?.getSymbol()
            let removeDollar = symbol?.dropFirst()
            print ("******\(removeDollar)")
            myModel.getAdded(addTerm: String(removeDollar!))
            searchController.isActive = false
            searchAddStock = true
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button click")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myModel.currentStocks?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func isFiltering() -> Bool {
        print("I'm in isFiltering")
        titleLabel1.text = "Symbol"
        titleLabel2.text = "Last"
        titleLabel3.text = "Change"
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        print("I'm in searchBarIsEmpty")
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func reloadTableView(){
        self.tableView.reloadData()
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        print ("I'm in filterContent")
        if(searchBarIsEmpty() == false){
        return searchStocks.getStockSearch(searchTerm: searchText, completionHandler: self.tableView.reloadData)
        }else{
            self.tableView.reloadData()
        }
    }

}


extension StockViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        print ("I'm in updateSearchResults")
    }
}
