//
//  PlayerDetailViewController.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 03/09/2022.
//

import UIKit

protocol playerDetailDelegate {
    func updateScore(for player: String, with score: String)
}

class PlayerDetailViewController: UIViewController {
    var playerData: Score? = nil
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var newScore: UITextField!
    
    var delegate: playerDetailDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(playerData)
        playerName.text = playerData?.name
        if let score = playerData?.score {
            playerScore.text = score
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        title = playerData?.name
    }
    
    @objc func doneButtonTapped() {
        delegate?.updateScore(for: playerData!.name, with: newScore.text ?? "")
        //print(newScore.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePlayerTapped(_ sender: UIButton) {
        
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
