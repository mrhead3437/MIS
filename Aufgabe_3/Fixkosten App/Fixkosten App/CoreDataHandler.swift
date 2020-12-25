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
