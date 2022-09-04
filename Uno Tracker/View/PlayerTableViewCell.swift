//
//  TableViewCell.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 21/08/2022.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var playerIcon: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addOnClick(_ sender: UIButton) {
        
    }
    
    func setIcon(playerNamed name: String) {
        if let firstChar = name.first{
            playerIcon.text = String(firstChar.uppercased())
        }
    }
    class var reuseIdentifier: String {
        return "PlayerCell"
    }
    
    class var nibName: String {
        return "PlayerTableViewCell"
    }
    
    func configureResultCell(text: String, score: String) {
        playerName.text = text
        playerScore.text = score
        setIcon(playerNamed: text)
    }
    
}
