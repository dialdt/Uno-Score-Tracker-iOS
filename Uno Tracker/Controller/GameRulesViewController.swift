//
//  GameRulesViewController.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 10/09/2022.
//

import UIKit

class GameRulesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func houseRulesTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.toHouseRules, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
