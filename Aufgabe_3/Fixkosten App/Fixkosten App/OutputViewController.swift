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
    
    @IBOutlet weak var allCarCostsLabel: UILabel!
    @IBOutlet weak var allPhoneCostsLabel: UILabel!
    @IBOutlet weak var allHouseCostsLabel: UILabel!
    @IBOutlet weak var allInmsuranceCostsLabel: UILabel!
    @IBOutlet weak var allInvestCostsLabel: UILabel!
    
    @IBOutlet weak var sumOfCostsLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCosts()
    }
    /**
     Calculates the sum of all costs for a category, which is passed as a parameter.
     - Parameters:
        - cellItem: Entitiy from Database
     - Returns: Sum of all costs for a category
     */
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
        
        allCarCostsLabel.text = String(getCost(cellItem: carCosts)) + " €"
        allPhoneCostsLabel.text = String(getCost(cellItem: phoneCosts)) + " €"
        allHouseCostsLabel.text = String(getCost(cellItem: homeCosts)) + " €"
        allInmsuranceCostsLabel.text = String(getCost(cellItem: insuranceCosts)) + " €"
        allInvestCostsLabel.text = String(getCost(cellItem: investCosts)) + " €"
        
        sumOfCostsLabel.text = String(getCost(cellItem: carCosts) + getCost(cellItem: phoneCosts) + getCost(cellItem: homeCosts) + getCost(cellItem: insuranceCosts) + getCost(cellItem: investCosts)) + " €"
    }
}
