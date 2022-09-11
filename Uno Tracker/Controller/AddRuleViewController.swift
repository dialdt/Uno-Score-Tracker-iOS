//
//  AddRuleViewController.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 10/09/2022.
//

import UIKit

protocol addRuleDelegate {
    func addRule(with description: String)
}

class AddRuleViewController: UIViewController {
    @IBOutlet weak var addRuleTextField: UITextField!
    var delegate: addRuleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Add New Rule"
        
        //view.backgroundColor = .systemPink
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(5), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(send), for: .touchUpInside)
        addRuleTextField.rightView = button
        addRuleTextField.rightViewMode = .always
    }
    
    @objc func send() {
        delegate?.addRule(with: addRuleTextField.text ?? "")
        self.dismiss(animated: true)
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
