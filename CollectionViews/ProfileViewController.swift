//
//  ProfileViewController.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-08.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = UserDefaults.standard.string(forKey: "username")!
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

    }

    @IBAction func LogOutButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize();
        let loginView = self.storyboard?.instantiateViewController(identifier: "LoginPageViewController") as! LoginPageViewController
        loginView.navigationItem.hidesBackButton = true
        loginView.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(loginView, animated: true)
        //unwind segue
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

