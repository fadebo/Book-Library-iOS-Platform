//
//  LoginPageViewController.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-08.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var UserTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignInTapped(_ sender: Any) {
        let username = UserTextField.text!
        let password = passTextField.text!
        
        let usernameStored = UserDefaults.standard.string(forKey: "username")!
        let passwordStored = UserDefaults.standard.string(forKey: "userPassword")!
        
        if(usernameStored == username){
            if(passwordStored == password){
                // Login Successful
                
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize();
                
                let myAlerts = UIAlertController(title: "Alert", message: "Login is Successful. Welcome \(username)!", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
//                    let homeView = self.storyboard?.instantiateViewController(identifier: "TabViewController") as! ViewController
//                    homeView.modalPresentationStyle = .fullScreen
//                    self.navigationController?.showDetailViewController(homeView, sender: nil)
//                        // Set the modal presentation style to full screen
                       let tabBarController = self.tabBarController
                    let navigationController = tabBarController?.viewControllers?[0] as? UINavigationController
                        let homeView = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! ViewController
                        homeView.navigationItem.hidesBackButton = true
//                    homeView.navigationItem.bar
                    self.navigationController?.pushViewController(homeView, animated: true)
                })
                myAlerts.addAction(okAction)
                present(myAlerts, animated: true)
                
                
            }else{
                displayAlertMessage(userMessage: "Incorrect Password");
                return;
            }
        }else{
            displayAlertMessage(userMessage: "Username not found");
            return;
        }
    }
    func displayAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default);
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true)
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
