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
        loadItems()
    }
    //MARK: functions
    /**
     Serves as a getter method for the array of individual categories and their items.
     - Parameters:
        - section: The corresponding category
        - index: The position or number of the respective item
     - Returns: Returns the items from a category..
     */
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
    /**
     Save and store data of CoreData object into Smartphone.
     - Parameters:
        - category: The associated category of the item
        - name: The name of the item
        - cost: The cost of the item
        - startDate: The start date of the item
        - duration: The duration of the item
        - endDate: The end date of the item
     */
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
        default: break
        }
        saveItem()
    }
    /**
     Fetch and load data of CoreData object from Smartphone.
     */
    func loadItems() {
        let getRequest: NSFetchRequest<CellItemData> = NSFetchRequest<CellItemData>(entityName: "CellItemData")
        do {
            let cellItems = try context.fetch(getRequest)
            
            for i in cellItems {
                switch i.category {
                case "Auto": carCosts.append(i)
                case "Telefon": phoneCosts.append(i)
                case "Haushalt": homeCosts.append(i)
                case "Versicherung": insuranceCosts.append(i)
                case "Sparplan": investCosts.append(i)
                default: break
                }
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    /**
     Save context of CoreData object.
     */
    func saveItem() {
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    /**
     Delete an item from the array of individual categories and their items.
     - Parameters:
        - section: The corresponding category
        - index: The position or number of the respective item
     */
    func deleteItem(section: Int, index: Int){
        context.delete(getCellItem(section: section, index: index))
           
        saveItem()
        
        switch section {
        case 0: carCosts.remove(at: index)
        case 1: phoneCosts.remove(at: index)
        case 2: homeCosts.remove(at: index)
        case 3: insuranceCosts.remove(at: index)
        default:
            investCosts.remove(at: index)
        }
    }
    /**
     Counts the number of elements in a given category
     - Parameters:
        - section: The corresponding category of an item
     */
    func count(section: Int) -> Int {
        var count = 0
        switch section {
        case 0: count = carCosts.count
        case 1: count = phoneCosts.count
        case 2: count = homeCosts.count
        case 3: count = insuranceCosts.count
        case 4: count = investCosts.count
        default: break
        }
        return count
    }
}
