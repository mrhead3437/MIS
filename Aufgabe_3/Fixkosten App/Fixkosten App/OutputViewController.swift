//
//  OutputViewController.swift
//  Fixkosten App
//
//  Created by Fatih Bas on 15.01.21.
//

import UIKit

class OutputViewController: UIViewController {
    
    var carCosts: [CellItemData]? 
    var phoneCosts: [CellItemData]?
    var homeCosts: [CellItemData]?
    var insuranceCosts: [CellItemData]?
    var investCosts: [CellItemData]?
    var result = Int()
    

    @IBOutlet weak var outputLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        showCosts()
    }
    
    func getCost(cellItem: [CellItemData]?) -> Int {
        result = 0
        let number = cellItem!.count
        if number > 0 {
            for index in 0...number - 1 {
                let buf = cellItem![index].cost?.replacingOccurrences(of: " €", with: "")
                let buffer = Int(buf!)
                result += buffer!
            }
        }
        return result
    }
    func showCosts() {
            outputLabel.text = "Autokosten: \(String(getCost(cellItem: carCosts))) € \n" +
                "Telefonkosten: \(String(getCost(cellItem: phoneCosts))) € \n" +
                "Haushalt: \(String(getCost(cellItem: homeCosts))) € \n" +
                "Versicherungskosten: \(String(getCost(cellItem: insuranceCosts))) € \n" +
                "Investitionskosten: \(String(getCost(cellItem: investCosts))) € \n" +
                " \n" +
                " Gesamt: \((String(getCost(cellItem: carCosts) + getCost(cellItem: phoneCosts) + getCost(cellItem: homeCosts) + getCost(cellItem: insuranceCosts) + getCost(cellItem: investCosts)))) €"
    }
}
