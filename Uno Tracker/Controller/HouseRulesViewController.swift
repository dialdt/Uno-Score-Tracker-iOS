//
//  HouseRulesViewController.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 09/09/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class HouseRulesViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    var rules: [Rule] = []
    let userID = "teams"
    var nextRuleID: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: RuleTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: RuleTableViewCell.reuseIdentifier)
        getRules()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Rule", style: .done, target: self, action: #selector(presentModal))
        //navigationController?.isNavigationBarHidden = false
        title = "Rules"

        // Do any additional setup after loading the view.
    }
    
    @objc func presentModal(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: K.addRuleStoryboard) as! AddRuleViewController
        destinationViewController.delegate = self
        if let sheet = destinationViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(destinationViewController, animated: true, completion: nil)
    }
    
    func getRules() {
        db.collection(userID).document("test").collection("rules").document("rules")
            .addSnapshotListener { [self] documentSnapshot, error in
            
            self.rules = []
              
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
                //addNewPlayerButton.isHidden = false
              print("Document data was empty.")
                //If document doesn't exist, create it
                db.collection("teams").document(userID).setData([
                  //Start with dummy value
                  "player.Score": "0",
                  "player.dateCreated": Date(timeIntervalSince1970: 0),
                  "player.friendlyName": "newPlayer",
                  "player.winStreak": "0"
                ])
                //and delete the default field
                //Hide add new player button
              return
            }
            
            rules = sortData(sort: data)
            nextRuleID = String(rules.count + 1)

          DispatchQueue.main.async {
              self.tableView.reloadData()
          }

      }
    }
    
    func sortData(sort data: [String: Any]) -> [Rule] {
        var i: [Rule] = []
        var output: [Rule] = []
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        for (key, value) in data {
            if let ruleData = data[key] as? [String: Any] {
                let ruleID = ruleData["ruleID"]
                let ruleDescription = ruleData["ruleDescription"]
                let ruleCreated = UnoGlobalFunctions.convertTimestampToTimeInterval(using: ruleData["ruleCreated"] as! Timestamp)
                i.append(Rule(ruleID: ruleID as! String, ruleDescription: ruleDescription as! String, ruleCreated: ruleCreated))
            }
        }
        
        output = i.sorted(by: {$0.ruleCreated < $1.ruleCreated})
        
        return output
        
    }
    
    func addNewRule(with description: String) {
        db.collection(userID).document("test").collection("rules").document("rules")
            .updateData([
                "\(nextRuleID).ruleID": nextRuleID,
                "\(nextRuleID).ruleDescription": description,
                "\(nextRuleID).ruleCreated": Date()
            ])
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

extension HouseRulesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rule = rules[indexPath.row]
        let cell  = tableView.dequeueReusableCell(withIdentifier: RuleTableViewCell.reuseIdentifier, for: indexPath) as! RuleTableViewCell
        cell.configureCell(id: rule.ruleID, description: rule.ruleDescription, created: rule.ruleCreated)
        return cell
    }

}

extension HouseRulesViewController: addRuleDelegate {
    func addRule(with description: String) {
        print("delegate triggered")
        addNewRule(with: description)
    }
    
}
