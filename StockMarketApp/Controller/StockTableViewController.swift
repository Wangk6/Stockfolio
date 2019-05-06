//
//  TableViewController.swift
//  StockMarketApp
//
//  Created by david on 5/3/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit

class StockTableViewController: UITableViewController, UISearchBarDelegate {
    var myModel = StockInfoCollection()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.rowHeight = 90.0
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let symbol = searchBar.text
        myModel.getAdded(addTerm: symbol!)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
            myModel.getStockSearch(searchTerm: searchText, completionHandler: self.tableView.reloadData)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("My stock count\(myModel.getStockCount())")
        return (myModel.currentStocks?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath)
        let row = indexPath.row
        if let actualCell = cell as? StockTableViewCell,
            let theStock = myModel.currentStocks?[row]{
                // reload
                actualCell.stockName.text = theStock.getSymbol()
                actualCell.stockLastPrice.text = theStock.getPrice()
                print("Adding cell")
                self.tableView.reloadRows(
                    at: [indexPath],
                    with: .automatic)
            }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myModel.currentStocks?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
