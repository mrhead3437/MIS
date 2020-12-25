//
//  ViewController.swift
//  Fixkosten App
//
//  Created by Fatih Bas on 22.11.20.
//

import UIKit

class ViewController: UIViewController {
    static let categorySelectionTitle = "Kategorie"
    static let categorySelectionMessage = "Bitte wählen Sie eine Kategorie aus."
    static let createInputTitle = "Fixkosten hinzufügen"
    static let createInputMessage = "Bitte Daten eingeben."
    static let placeholderInputName = "Name"
    static let placeholderInputCost = "Kosten"
    static let placeholderInputStartDate = "Startdatum der Fixkosten"
    static let placeholderInputEndDate = "Enddatum der Fixkosten"
    static let placeholderInputDuration = "Dauer der Fixkosten"
    static let currency = "€"
    
    var category: [String] = ["Auto", "Telefon", "Haushalt", "Versicherung", "Sparplan"]
    let datePicker = UIDatePicker()
    var date = UITextField()
    
    @IBOutlet weak var fixedCostsTableView: UITableView!
    
    /**
     Add new Item to a category with an alert
     */
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let categorySelectionAlert = UIAlertController(title: ViewController.categorySelectionTitle, message: ViewController.categorySelectionMessage , preferredStyle: .alert)
        
        for i in 0..<category.count {
            categorySelectionAlert.addAction(
                createAction(category: category[i]))
        }
        
        self.present(categorySelectionAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add extentions
        fixedCostsTableView.delegate = self
        fixedCostsTableView.dataSource = self
        // Do any additional setup after loading the view.
            //iOS 14 or greater
            if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .inline
            }
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
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoraDataHandler.singleton.count(section: section)
    }
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CellItem
        return itemCell
    }
    
//MARK: functions
    /**
     Creates a form to enter the data for the fixed costs.
     */
    func createInputForm(category: String) {
        let inputAlert = UIAlertController(title: ViewController.createInputTitle , message: ViewController.createInputMessage, preferredStyle: .alert)
        
        //name
        inputAlert.addTextField { (nameTextField) in
            nameTextField.placeholder = ViewController.placeholderInputName
        }
        
        //cost
        inputAlert.addTextField { (costTextField) in
            costTextField.placeholder = ViewController.placeholderInputCost
            costTextField.keyboardType = .decimalPad
            costTextField.addTarget(self, action: #selector(self.addCurrency(_:)), for: .editingDidEnd)
            costTextField.addTarget(self, action: #selector(self.clearTextField(_:)), for: .editingDidBegin)
        }
        
        //startDate
        inputAlert.addTextField { (startDateTextField) in
            startDateTextField.placeholder = ViewController.placeholderInputStartDate
            startDateTextField.addTarget(self, action: #selector(self.openDatePicker(_:)), for: .touchDown)
        }
        
        //endDate
        inputAlert.addTextField { (endDateTextField) in
            endDateTextField.placeholder = ViewController.placeholderInputEndDate
        }
        
        //duration
        inputAlert.addTextField { (durationTextField) in
            durationTextField.placeholder = ViewController.placeholderInputDuration
            durationTextField.keyboardType = .numberPad
        }
        
        let saveButton = UIAlertAction(title: "Speichern", style: .default) { (saveButton) in
            
        }
        
        let cancelButton = UIAlertAction(title: "Abbrechen", style: .default) { (cancelButton) in
            
        }
        
        inputAlert.addAction(saveButton)
        inputAlert.addAction(cancelButton)
        
        self.present(inputAlert, animated: true, completion: nil)
    }
    
    /**
     Lists all existing categories in the alert.
     */
    func createAction(category: String) -> UIAlertAction {
        let action = UIAlertAction(title: category, style: .default) { (action) in
            let choosenCategory = action.title!
            self.createInputForm(category: choosenCategory)
        }
        return action
    }
    /**
     Adds a currency when the user has added the cost.
     */
   @objc func addCurrency(_ textField: UITextField) {
        if ((textField.text?.isEmpty) == nil) {
            textField.text = ""
        } else {
            textField.text! += ViewController.currency
        }
    }
    
    /**
     Clear text before the user beginns to write something
     */
    @objc func clearTextField(_ textField: UITextField) {
        textField.text = ""
    }
    /**
     Open date picker and select a date.
     */
    @objc func openDatePicker(_ textField: UITextField) {
        date = textField
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
    }
    /**
     Adjust the formatting of the date and write it in the corresponding text field.
     */
    @objc func changeDate(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "de_DE")
        let dateAsString = dateFormatter.string(from: datePicker.date)
        date.text = dateAsString
    }
}

