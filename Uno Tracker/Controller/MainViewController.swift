//
//  ViewController.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 21/08/2022.
//


import UIKit
import FirebaseCore
import FirebaseFirestore
//import FirebaseAuth

class MainViewController: UIViewController, playerDetailDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var addNewPlayerButton: UIButton!
    var dataManager = UnoDataManager()
    let db = Firestore.firestore()
    var scores: [Score] = []
    var userID: String = ""
    var newPlayer: String = ""
    var currentScore: Double = 0.0
    //var playerDetail: PlayerDetailViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: PlayerTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PlayerTableViewCell.reuseIdentifier)
        loadScores()
        print("mainVC userID", userID)
        //addNewPlayerButton.isHidden = true
        //dataManager.loadScores()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.addPlayerSegue {
            let addPlayerVCNC = segue.destination as! UINavigationController
            let addPlayerVC = addPlayerVCNC.topViewController as! AddPlayerViewController
            addPlayerVC.delegate = self
        } else if segue.identifier == K.playerDetailSegue {
            let playerDetailVCNC = segue.destination as! UINavigationController
            if let playerDetailVC = playerDetailVCNC.topViewController as? PlayerDetailViewController, let data = sender as? Score {
                playerDetailVC.playerData = data
                playerDetailVC.delegate = self
            }
        }
    }
    
    func loadScores() {
        
        db.collection("teams").document(userId)
            .addSnapshotListener { [self] documentSnapshot, error in
                
              self.scores = []
                
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
                    "name": "0"
                  ])
                  //and delete the default field
                  //Hide add new player button
                return
              }
                //print(data)
                scores = sortData(sort: data)
                //print(scores)
                /*for (name, score) in data {
                    print(name, score)
                    if let num = score as? String {
                        scores.append(Score(name: name, score: num))
                    }
                    
                    //scores.append(Score(name: name, score: score))
                }*/
                
                //sort by score
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //let indexPath = IndexPath(row: self.scores.count - 1, section: 0)
                    //self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                
            }
                //print(scores.count)
        }
        
    }
    
    func sortData(sort data: [String: Any]) -> [Score] {
        var i: [String: Double] = [:]
        var output: [Score] = []
        for (name, score) in data {
            if let num = score as? String {
                let s = Double(num)
                i[name] = s
            }
            
        }
        let sortedData = i.sorted(by: {$0.value > $1.value})
        
        for (key, value) in sortedData {
            output.append(Score(name: key, score: String(format: "%.0f", value)))
        }
        
        return output
        
    }
    
    func addNewPlayer(named name: String) {
        db.collection("teams").document(userID)
            .updateData([
                name: "0"
            ])
    }
    
    func updateScores(for player: String, with score: String) {
        print(player, score)
        currentScore += Double(score) ?? 0.0
        print(currentScore)
        let newScore = String(format: "%.0f", currentScore)
        print(newScore)
        db.collection("teams").document(userID)
            .updateData([
                    player: newScore
            ])
        

    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(tableViewDataSource[section])
        print(scores.count)
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let score = scores[indexPath.row]
        print(score)
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.reuseIdentifier, for: indexPath) as! PlayerTableViewCell
        cell.configureResultCell(text: score.name, score: score.score)
        cell.frame.size.width = tableView.frame.width
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row, scores)
        let data = scores[indexPath.row]
        currentScore = Double(scores[indexPath.row].score) ?? 0.0
        self.performSegue(withIdentifier: K.playerDetailSegue, sender: data)
        
    }
    
    
    
    
}

extension MainViewController: addPlayerDelegate {
    func addPlayer(player: String) {
        print("Main VC", player)
        addNewPlayer(named: player)
        loadScores()
        //getScores()
        //addNewPlayerButton.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func updateScore(for player: String, with score: String) {
        updateScores(for: player, with: score)
    }
    
}

