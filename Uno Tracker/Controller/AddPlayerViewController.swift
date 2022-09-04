//
//  AddPlayerViewController.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 23/08/2022.
//

import UIKit

protocol addPlayerDelegate {
    func addPlayer(player: String)
}

class AddPlayerViewController: UIViewController {
    
    var delegate: addPlayerDelegate?
    
    @IBOutlet weak var newPlayer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        //navigationController?.isNavigationBarHidden = false
        title = "Add Player"
    }
    
    public var completion: ((String?) -> (Void))?
    
    @objc func doneButtonTapped() {
        delegate?.addPlayer(player: newPlayer.text ?? "")
        print(newPlayer.text)
        self.dismiss(animated: true, completion: nil)
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
