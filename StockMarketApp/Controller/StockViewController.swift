//
//  StockViewController.swift
//  StockMarketApp
//
//  Created by david on 5/6/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit
import CoreData

class StockViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var searchStocks = StockInfoCollection()
    var myModel = StockInfoCollection()
    var dataNum = 0
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    
    var searchBar: UISearchBar!
    var searchAddStock = true
    var symbolSave: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Coredata
        
        dataNum = getData()
        for symbol in symbolSave{
            myModel.getAdded(addTerm: symbol, completionHandler: self.tableView.reloadData)
        }
        self.tableView?.rowHeight = 80.0
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.gray
        searchController.searchBar.tintColor = UIColor.gray
        searchController.searchBar.barStyle = .black
        self.tableView.backgroundColor = UIColor.clear
        searchController.searchBar.placeholder = "Search Stocks"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing)) // create a bat button
        navigationItem.rightBarButtonItem = editButton // assign button
        self.tableView.reloadData()

    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        if(myModel.getStockCount() < dataNum){
            for symbol in symbolSave{
                myModel.getAdded(addTerm: symbol, completionHandler: self.tableView.reloadData)
            }
        }
    }
    @objc private func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true) // Set opposite value of current editing status
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit" // Set title depending on the editing status
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath)
        let row = indexPath.row
        if let actualCell = cell as? StockTableViewCell
            {
            // reload
            
            if isSearching(){
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
                searchAddStock = false
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
                if theStock?.change.first == "-"{
                    actualCell.changeP.textColor = UIColor.red
                    actualCell.change.textColor = UIColor.red
                } else {
                    actualCell.change.textColor = UIColor.green
                    actualCell.changeP.textColor = UIColor.green
                }
                searchAddStock = true
                print("Adding actual cell")

            }
        }
        if(searchAddStock == true){
        searchAddStock = false
        return cell
        } else {            self.tableView.reloadRows(
            at: [indexPath],
            with: .automatic); return cell}
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("My stock count\(myModel.getStockCount())")
        if isSearching() {return (searchStocks.searchStock?.count)!}
            else {return (myModel.currentStocks?.count)!}
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searchBarIsEmpty() == true) {
            print("Added row selected")
        }
        else if(searchController.isActive == true){
            let search = (searchStocks.searchStock?[indexPath.row])
            let symbol = search?.getSymbol()
            let removeDollar = symbol?.dropFirst()
            addStock(symbol: String(removeDollar!))
        }
    }
    
    func addStock(symbol: String){
        //Save the data
        let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Stocks", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        self.symbolSave.append(symbol)
        newEntity.setValue(symbol, forKey: "symbol")
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Failed saving")
        }
        //Add
        searchAddStock = true
        searchController.isActive = false
        myModel.getAdded(addTerm: String(symbol)){
            self.tableView.reloadData()
        }
    }
    func getData()->Int{
        
        let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stocks")
        request.returnsObjectsAsFaults = false
        print("IM GETTING DATA")
        var dataCount = 0
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                dataCount = dataCount + 1
                self.symbolSave.append(data.value(forKey: "symbol") as! String)
            }
        } catch  {
            print ("Failed getData")
        }
        return dataCount
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print ("In shouldPerform")
        if searchAddStock == false {
            return false
        } else {
            return true
            
        }
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && searchBarIsEmpty() == true {
            // Delete the row from the data source
            let myStock = self.myModel.currentStocks?.remove(at: indexPath.row)
            _ = myStock?.getSymbol().dropFirst()
            deleteData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func deleteData(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Stocks")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? StockDetailViewController{
            dvc.myStock = myModel.currentStocks![(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
 
    func isSearching() -> Bool {
        print("I'm in isSearching")
        titleLabel1.text = "Symbol"
        titleLabel2.text = "Last"
        titleLabel3.text = "Change"
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        print("I'm in searchBarIsEmpty")
        searchAddStock = true
        return searchController.searchBar.text?.isEmpty ?? true
    }

    
    func searchContentForSearchText(_ searchText: String, scope: String = "All") {
        print ("I'm in filterContent")

        if(searchBarIsEmpty() == false){
            return searchStocks.getSearch(searchTerm: searchText, completionHandler: self.tableView.reloadData)
        }
    }
}




extension StockViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        searchContentForSearchText(searchController.searchBar.text!)
        print ("I'm in updateSearchResults")
        
        //Refreh the table with loaded data and not searchbar data
        if !searchController.isActive {
            print("Cancelled")
            self.tableView.reloadData()
        }
    }
}

