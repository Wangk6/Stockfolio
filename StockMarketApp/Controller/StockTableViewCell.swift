//
//  TableViewCell.swift
//  StockMarketApp
//
//  Created by david on 5/3/19.
//  Copyright © 2019 KevinWang. All rights reserved.
//

import UIKit


class StockTableViewCell: UITableViewCell {
    var myModel = StockInfoCollection()

    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockLastPrice: UILabel!
    @IBOutlet weak var changeP: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var stockFullName: UILabel!
    @IBOutlet weak var stockSymbol: UILabel!
    
}
