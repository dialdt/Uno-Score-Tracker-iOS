//
//  PlayerDetailViewController.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 03/09/2022.
//

import UIKit

protocol playerDetailDelegate {
    func updateScore(for player: String, with score: String)
    func deletePlayer(named player: String)
}

class PlayerDetailViewController: UIViewController {
    var playerData: Player? = nil
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var newScore: UITextField!
    @IBOutlet weak var winStreak: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var lastWin: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var loses: UILabel!
    
    var delegate: playerDetailDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY HH:mm"
        //print(playerData)
        playerScore.text = String(playerData?.score ?? 0)
        winStreak.text = String(playerData?.winStreak ?? 0)
        dateCreated.text = formatter.string(from: Date(timeIntervalSince1970: playerData?.dateCreated ?? 0))
        lastWin.text = formatter.string(from: Date(timeIntervalSince1970: playerData?.lastWin ?? 0))
        wins.text = String(playerData?.wins ?? 0)
        loses.text = String(playerData?.loses ?? 0)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "\(UIImage(systemName: "chevron.left")) Back", style: .plain, target: self, action: #selector(backButtonTapped))
        title = playerData?.name
    }
    
    @objc func doneButtonTapped() {
        showUpdateScoreAlert()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func winnerButtonTapped(_ sender: UIButton) {
        showUpdateScoreAlert()
    }
    
    @IBAction func deletePlayerTapped(_ sender: UIButton) {
        showDeletePlayerAlert()
    }
    

    
    private func showUpdateScoreAlert() {
        let alertController = UIAlertController(title: "Confirm", message: "Are you sure you want to update this player's score?", preferredStyle: .actionSheet)
        let yesAlertAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.delegate?.updateScore(for: self.playerData!.name, with: self.newScore.text ?? "")
            self.dismiss(animated: true, completion: nil)
        })
        let noAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(yesAlertAction)
        alertController.addAction(noAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showDeletePlayerAlert() {
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this player", preferredStyle: .actionSheet)
        let yesAlertAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.delegate?.deletePlayer(named: self.playerData!.name)
            self.dismiss(animated: true, completion: nil)
        }
        let noAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(yesAlertAction)
        alertController.addAction(noAlertAction)
        present(alertController, animated: true, completion: nil)
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
