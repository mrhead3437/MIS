//
//  ViewController.swift
//  Fixkosten App
//
//  Created by Fatih Bas on 22.11.20.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Strings
    static let labelFont = "HelveticaNeue-Medium"
    static let categorySelectionTitle = "Kategorie"
    static let categorySelectionMessage = "Bitte wählen Sie eine Kategorie aus."
    static let createInputTitle = "Fixkosten hinzufügen"
    static let createInputMessage = "Bitte Daten eingeben."
    static let placeholderInputName = "Name"
    static let placeholderInputCost = "Kosten"
    static let placeholderInputStartDate = "Startdatum der Fixkosten"
    static let placeholderInputEndDate = "Enddatum der Fixkosten"
    static let placeholderInputDuration = "Dauer der Fixkosten"
    static let saveButtonLabel = "Speichern"
    static let cancelButtonLabel = "Abbrechen"
    static let currency = " €"
    static let durrationTimeName = " Monate"
    static let dateFormatString = "dd MMM yyyy"
    static let dateLocationString = "de_DE"
    static let checkUserInputErrorString = "User Eingabe fehlerhaft oder nicht vorhanden!"
    //MARK: - global variables
    var category: [String] = ["Auto", "Telefon", "Haushalt", "Versicherung", "Sparplan"]
    let datePicker = UIDatePicker()
    var startDate = UITextField()
    var endDate = UITextField()
    var durrationInMonth = UITextField()
    
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

//MARK: - delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray
        
        let label = UILabel()
        label.text = category[section]
        label.font = UIFont(name: ViewController.labelFont, size: 25)
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoraDataHandler.singleton.deleteItem(section: indexPath.section, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
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
        
        let item = CoraDataHandler.singleton.getCellItem(section: indexPath.section, index: indexPath.row)
        
        itemCell.nameOfItem.text = item.name
        itemCell.costOfItem.text = item.cost
        itemCell.startDateOfItem.text = item.startDate
        itemCell.durationOfItem.text = item.duration
        itemCell.endDateOfItem.text = item.endDate
        
        return itemCell
    }
    
//MARK: - functions
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
            startDateTextField.addTarget(self, action: #selector(self.openDatePickerForStartDate(_:)), for: .touchDown)
        }

        //duration
        inputAlert.addTextField { (durationTextField) in
            durationTextField.placeholder = ViewController.placeholderInputDuration
            durationTextField.keyboardType = .numberPad
            durationTextField.addTarget(self, action: #selector(self.calculateEndDate(_:)), for: .editingDidEnd)
            durationTextField.addTarget(self, action: #selector(self.addDurrationTime(_:)), for: .editingDidEnd)
        }
        
        //endDate
        inputAlert.addTextField { (endDateTextField) in
            self.endDate = endDateTextField
            endDateTextField.placeholder = ViewController.placeholderInputEndDate
            endDateTextField.addTarget(self, action: #selector(self.openDatePickerForEndDate(_:)), for: .touchDown)
        }
        
        let saveButton = UIAlertAction(title: ViewController.saveButtonLabel, style: .default) { (saveButton) in
            let name = self.checkUserInput(value: inputAlert.textFields![0].text!)
            let cost = self.checkUserInput(value: inputAlert.textFields![1].text!)
            let startDate = self.checkUserInput(value: inputAlert.textFields![2].text!)
            let duration = self.checkUserInput(value: inputAlert.textFields![3].text!)
            let endDate = self.checkUserInput(value: inputAlert.textFields![4].text!)
            
            CoraDataHandler.singleton.addNewItem(category: category, name: name, cost: cost, startDate: startDate, duration: duration, endDate: endDate)
            
            self.fixedCostsTableView.reloadData()
            
        }
        
        let cancelButton = UIAlertAction(title: ViewController.cancelButtonLabel, style: .default) { (cancelButton) in
            
        }
        
        inputAlert.addAction(saveButton)
        inputAlert.addAction(cancelButton)
        
        self.present(inputAlert, animated: true, completion: nil)
    }
    
    /**
     Lists all existing categories in the alert and create a cost in choosen category.
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
     Adds a durration time name when the user has added the durration.
     */
    @objc func addDurrationTime(_ textField: UITextField){
        if ((textField.text?.isEmpty) == nil) {
            textField.text = ""
        } else {
            textField.text! += ViewController.durrationTimeName
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
    @objc func openDatePickerForStartDate(_ textField: UITextField) {
        startDate = textField
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDateForStartDate(_:)), for: .valueChanged)
    }
    /**
     Adjust the formatting of the date and write it in the corresponding text field.
     */
    @objc func handleDateForStartDate(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ViewController.dateFormatString
        dateFormatter.locale = Locale(identifier: ViewController.dateLocationString)
        let dateAsString = dateFormatter.string(from: datePicker.date)
        if dateAsString.isEmpty{
            return
        } else {
            startDate.text = dateAsString
        }
    }
    
    /**
     Open date picker and select a date.
     */
    @objc func openDatePickerForEndDate(_ textField: UITextField) {
        endDate = textField
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDateForEndDate(_:)), for: .valueChanged)
    }
    /**
     Adjust the formatting of the date and write it in the corresponding text field.
     */
    @objc func handleDateForEndDate(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ViewController.dateFormatString
        dateFormatter.locale = Locale(identifier: ViewController.dateLocationString)
        let dateAsString = dateFormatter.string(from: datePicker.date)
        if dateAsString.isEmpty{
            return
        } else {
            endDate.text = dateAsString
        }
    }
    
    @objc func calculateEndDate(_ textField: UITextField) {
        if ((textField.text?.isEmpty) == nil) {
            textField.text = ""
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = ViewController.dateFormatString
            dateFormatter.locale = Locale(identifier: ViewController.dateLocationString)
            
            let days = Int(textField.text!)! * 30
            let date = datePicker.date.addingTimeInterval(TimeInterval(60*60*24*days))
            endDate.text = dateFormatter.string(from: date)
        }
    }
    
        func getMonth(from fromDate: Date, to toDate: Date) -> String{
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        dateFormatter.dateFormat = ViewController.dateFormatString
        dateFormatter.locale = Locale(identifier: ViewController.dateLocationString)
        let diff = calendar.dateComponents([.month], from: fromDate, to: toDate)
            return String(diff.month!)
    }
    
    func checkUserInput(value: String?) -> String {
        if let userInput = value {
            return userInput
        } else {
            return ViewController.checkUserInputErrorString
        }
    }
}

