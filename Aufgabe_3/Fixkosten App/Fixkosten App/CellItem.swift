//
//  CellItem.swift
//  Fixkosten App
//
//  Created by Fatih Bas on 26.11.20.
//

import UIKit

class CellItem: UITableViewCell {
    
    @IBOutlet weak var nameOfItem: UILabel!
    @IBOutlet weak var costOfItem: UILabel!
    @IBOutlet weak var startDateOfItem: UILabel!
    @IBOutlet weak var endDateOfItem: UILabel!
    @IBOutlet weak var durationOfItem: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
