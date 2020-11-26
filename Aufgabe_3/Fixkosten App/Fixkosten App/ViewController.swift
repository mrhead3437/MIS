//
//  ViewController.swift
//  Fixkosten App
//
//  Created by Fatih Bas on 22.11.20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fixedCostsTableView: UITableView!
    
    var category: [String] = ["Auto", "Telefon", "Haushalt", "Versicherung", "Sparplan"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add extentions
        fixedCostsTableView.delegate = self
        fixedCostsTableView.dataSource = self
    }


}
//MARK: delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray
        
        let label = UILabel()
        label.text = category[section]
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
        label.frame = CGRect(x: 20, y: 5, width: 200, height: 35)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
//MARK: dataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    //Wie viele Tabellen Zeilen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    //Erstellt eine Tabellenzeile
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CellItem
        return itemCell
    }
    
    
}

