//
//  CoreDataHandler.swift
//  Fixkosten App
//
//  Created by Fatih Bas on 22.12.20.
//

import Foundation
import CoreData
import UIKit

class CoraDataHandler {
    
    //Array for Categories: "Auto", "Telefon", "Haushalt", "Versicherung", "Sparplan"
    var carCosts = [CellItemData] ()
    var phoneCosts = [CellItemData] ()
    var homeCosts = [CellItemData] ()
    var insuranceCosts = [CellItemData] ()
    var investCosts = [CellItemData] ()
    
    var context: NSManagedObjectContext!
    
    static let singleton = CoraDataHandler()
    
    //MARK: init
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    //MARK: functions
    
    func getCellItem(section: Int, index: Int) -> CellItemData {
        switch section {
        case 0: return carCosts[index]
        case 1: return phoneCosts[index]
        case 2: return homeCosts[index]
        case 3: return insuranceCosts[index]
        default:
            return investCosts[index]
        }
    }
    //Save data
    func addNewItem(category: String, name: String, cost: String, startDate: String, duration: String, endDate: String) {
        
        let cellItem = NSEntityDescription.insertNewObject(forEntityName: "CellItemData", into: context) as! CellItemData
        
        cellItem.category = category
        cellItem.name = name
        cellItem.cost = cost
        cellItem.startDate = startDate
        cellItem.duration = duration
        cellItem.endDate = endDate
        
        switch category {
        case "Auto": carCosts.append(cellItem)
        case "Telefon": phoneCosts.append(cellItem)
        case "Haushalt": homeCosts.append(cellItem)
        case "Versicherung": insuranceCosts.append(cellItem)
        case "Sparplan": investCosts.append(cellItem)
        default:
            break
        }
        
        saveItem()
    }
    
    func saveItem() {
        do {
            try context.save()
        } catch  {
            print("ERR")
        }
    }
    /**
     Number of elements in a category.
     */
    func count(section: Int) -> Int {
        var count = 0
        switch section {
        case 0: count = carCosts.count
        case 1: count = phoneCosts.count
        case 2: count = homeCosts.count
        case 3: count = insuranceCosts.count
        case 4: count = investCosts.count
        default:
            break
        }
        return count
    }
}
