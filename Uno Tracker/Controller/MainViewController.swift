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
    var dataManager = UnoGlobalFunctions()
    let db = Firestore.firestore()
    var scores: [Player] = []
    var userID: String = ""
    var newPlayer: String = ""
    var currentScore: Double = 0.0
    var currentWinStreak: Double = 0.0
    //var playerDetail: PlayerDetailViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: PlayerTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PlayerTableViewCell.reuseIdentifier)
        loadScores()
        //print("mainVC userID", userID)
        tabBarController?.tabBar.isHidden = false
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
            if let playerDetailVC = playerDetailVCNC.topViewController as? PlayerDetailViewController, let data = sender as? Player {
                playerDetailVC.playerData = data
                playerDetailVC.delegate = self
            }
        }
    }
    
    func loadScores() {
        
        db.collection("teams").document(userID)
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
                    "player.Score": "0",
                    "player.dateCreated": Date(timeIntervalSince1970: 0),
                    "player.friendlyName": "newPlayer",
                    "player.winStreak": "0"
                  ])
                  //and delete the default field
                  //Hide add new player button
                return
              }
                
            scores = sortData(sort: data)
            

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
        
    }
    
    func sortData(sort data: [String: Any]) -> [Player] {
        var i: [Player] = []
        var output: [Player] = []
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        for (key, value) in data {
            if let playerData = data[key] as? [String: Any] {
                let playerName = playerData["friendlyName"] as? String ?? ""
                let playerScore = playerData["Score"] as? Int ?? 0
                let playerCreatedDate = convertTimestampToTimeInterval(using: playerData["dateCreated"] as? Timestamp ?? Timestamp(seconds: 0, nanoseconds: 0))
                let playerWins = playerData["wins"] as? Int ?? 0
                let playerLoses = playerData["loses"] as? Int ?? 0
                let playerLastWin = convertTimestampToTimeInterval(using: playerData["lastWin"] as? Timestamp ?? Timestamp(seconds: 0, nanoseconds: 0))
                //convertTimestampToDate(using: (playerData["dateCreated"] as! Timestamp))
                let playerWinStreak = playerData["winStreak"] as? Int ?? 0
                i.append(Player(name: playerName, score: playerScore, winStreak: playerWinStreak, dateCreated: playerCreatedDate, wins: playerWins, loses: playerLoses, lastWin: playerLastWin))
            }
        }
        
        output = i.sorted(by: {$0.score > $1.score})
        
        return output
        
    }
    
    func convertTimestampToTimeInterval(using data: Timestamp) -> TimeInterval {
        //var outputDate: Date = Date(timeIntervalSince1970: 0)
        if let timestamp = data as? Timestamp {
            let date = timestamp.dateValue()
            let timeInSeconds = timestamp.seconds
            print("time in seconds", timeInSeconds)
            return TimeInterval(timeInSeconds)
        }
    }
    
    func addNewPlayer(named name: String) {
        db.collection("teams").document(userID)
            .updateData([
                "\(name).Score": 0,
                "\(name).dateCreated": Date(),
                "\(name).friendlyName": name,
                "\(name).winStreak": 0,
                "\(name).wins": 0,
                "\(name).loses": 0,
                "\(name).lastWin": Date(timeIntervalSince1970: 0)
            ])
    }
    
    func updateScores(for player: String, with score: String) {
        //print(player, score)
        currentScore += Double(score) ?? 0.0
        currentWinStreak += 1.0
        //let newScore = String(format: "%.0f", currentScore)
        //let newWinStreak = String(format: "%0.f", currentWinStreak)
        //print(newScore)
        db.collection("teams").document(userID)
            .updateData([
                "\(player).Score": FieldValue.increment(Int64(score) ?? 0),
                "\(player).winStreak": FieldValue.increment(Int64(1) ?? 0),
                "\(player).wins": FieldValue.increment(Int64(1) ?? 0)
            ])
        
        for name in filterData(filter: scores, exclude: player) {
            db.collection("teams").document(userID)
                .updateData([
                    "\(name).winStreak": 0,
                    "\(name).loses": FieldValue.increment(Int64(1))
                    
                ])
        }
        
        filterData(filter: scores, exclude: player)
    }
    
    func filterData(filter data: [Player], exclude player: String) -> [String] {
        let filteredData = data.filter({$0.name != player})
        var outputArray: [String] = []
        for i in filteredData {
            outputArray.append(i.name)
        }
        return outputArray
        
    }
    
    func delete(playerNamed player: String) {
        db.collection("teams").document(userID)
            .updateData([
                player: FieldValue.delete()
            ])
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(tableViewDataSource[section])
        //print(scores.count)
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
    
    func deletePlayer(named player: String) {
        delete(playerNamed: player)
    }
    
}

