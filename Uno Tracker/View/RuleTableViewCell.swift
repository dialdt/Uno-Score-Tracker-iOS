//
//  RuleTableViewCell.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 09/09/2022.
//

import UIKit

class RuleTableViewCell: UITableViewCell {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var reuseIdentifier: String {
        return "RuleCell"
    }

    class var nibName: String {
        return "RuleTableViewCell"
    }
    
    func convertTimetoString(using data: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: data))
    }
    
    func configureCell(id: String, description: String, created: TimeInterval) {
        idLabel.text = id
        descriptionLabel.text = description
        dateCreated.text = convertTimetoString(using: created)
    }
    
}
