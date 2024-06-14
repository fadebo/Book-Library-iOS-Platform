//
//  RegisterPageViewController.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-08.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {
    
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func SignUpTapped(_ sender: Any) {
        let username = userTextField.text!
        let userPassword = passTextField.text!
        let userRepeatPassord = repeatPassTextField.text!
        
        //check for empty fields
        if(((username.isEmpty)) || ((userPassword.isEmpty)) || ((userRepeatPassord.isEmpty))){
            //Display alert message
            displayAlertMessage(userMessage: "All field required");
            return;
        }
        //Check if passord match
        if(userPassword != userRepeatPassord){
            //Display alert message
            displayAlertMessage(userMessage: "Passwords do not match");
            return;
        }
        
        // Store data
        UserDefaults.standard.set(username, forKey: "username");
        UserDefaults.standard.set(userPassword, forKey: "userPassword");
        UserDefaults.standard.synchronize();
        
        //Display alert message with confirmation
        let myAlerts = UIAlertController(title: "Alert", message: "Registration is Successful. Welcome!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            let loginView = self.storyboard?.instantiateViewController(identifier: "LoginPageViewController") as! LoginPageViewController
            self.navigationController?.pushViewController(loginView, animated: true)
        })
    
        
        
        
        
        myAlerts.addAction(okAction)
        present(myAlerts, animated: true)
        
    }
    func displayAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default);
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true)
    }
}
