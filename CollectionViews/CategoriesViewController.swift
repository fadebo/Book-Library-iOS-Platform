//
//  CategoriesViewController.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-08.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

protocol CategoriesViewControllerDelegate: AnyObject{
    func didUpdateCategory(_ category: String)
}

class CategoriesViewController: UIViewController {
    weak var delegate: CategoriesViewControllerDelegate?
    
    @IBOutlet weak var Art: UIButton!
    @IBOutlet weak var FictionBtn: UIButton!
    @IBOutlet weak var BiologyBtn: UIButton!
    @IBOutlet weak var ChemistryBtn: UIButton!
    @IBOutlet weak var PhysicsBtn: UIButton!
    @IBOutlet weak var ProgrammingBtn: UIButton!
    @IBOutlet weak var MathsBtn: UIButton!
    @IBOutlet weak var FinanceBtn: UIButton!
    @IBOutlet weak var Archaeology: UIButton!
    @IBOutlet weak var PsychologyBtn: UIButton!
    
    var savedCategory: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        savedCategory = UserDefaults.standard.string(forKey: "category") ?? "History"
        // Do any additional setup after loading the view.
        if Art.currentTitle == savedCategory{
            Art.backgroundColor = UIColor.red
            Art.setTitleColor(UIColor.white, for: .normal)
        }else if FictionBtn.currentTitle == savedCategory{
            FictionBtn.backgroundColor = UIColor.red
            FictionBtn.setTitleColor(UIColor.white, for: .normal)
        }else if BiologyBtn.currentTitle == savedCategory{
            BiologyBtn.backgroundColor = UIColor.red
            BiologyBtn.setTitleColor(UIColor.white, for: .normal)
        }else if ChemistryBtn.currentTitle == savedCategory{
            ChemistryBtn.backgroundColor = UIColor.red
            ChemistryBtn.setTitleColor(UIColor.white, for: .normal)
        }else if PhysicsBtn.currentTitle == savedCategory{
            PhysicsBtn.backgroundColor = UIColor.red
            PhysicsBtn.setTitleColor(UIColor.white, for: .normal)
        }else if ProgrammingBtn.currentTitle == savedCategory{
            ProgrammingBtn.backgroundColor = UIColor.red
            ProgrammingBtn.setTitleColor(UIColor.white, for: .normal)
        }else if MathsBtn.currentTitle == savedCategory{
            MathsBtn.backgroundColor = UIColor.red
            MathsBtn.setTitleColor(UIColor.white, for: .normal)
        }else if FinanceBtn.currentTitle == savedCategory{
            FinanceBtn.backgroundColor = UIColor.red
            FinanceBtn.setTitleColor(UIColor.white, for: .normal)
        }else if Archaeology.currentTitle == savedCategory{
            Archaeology.backgroundColor = UIColor.red
            Archaeology.setTitleColor(UIColor.white, for: .normal)
        }else if PsychologyBtn.currentTitle == savedCategory{
            PsychologyBtn.backgroundColor = UIColor.red
            PsychologyBtn.setTitleColor(UIColor.white, for: .normal)
        } else {
            print("No saved category found in UserDefaults.")
        }
//        observeUserDefaultsChanges()
    }
    

    @IBAction func ArtBtn(_ sender: Any) {
         let category = Art.currentTitle?.lowercased()
        print(category!)
        UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    
    @IBAction func FictionBtn(_ sender: Any) {
        let category = FictionBtn.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
       NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    @IBAction func BiologyBtn(_ sender: Any) {
        let category = BiologyBtn.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    @IBAction func ChemistryBtn(_ sender: Any) {
        let category = ChemistryBtn.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    
    @IBAction func PhysicsBtn(_ sender: Any) {
        let category = PhysicsBtn.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    
    @IBAction func ProgrammingBtn(_ sender: Any) {
        let category = ProgrammingBtn.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    
    @IBAction func MathsBtn(_ sender: Any) {
        let category = MathsBtn.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    
    @IBAction func FinanceBtn(_ sender: Any) {
        let category = FinanceBtn.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    @IBAction func Archaeology(_ sender: Any) {
        let category = Archaeology.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
    }
    
    @IBAction func PsychologyBtn(_ sender: Any) {
        let category = PsychologyBtn.currentTitle?.lowercased()
       UserDefaults.standard.set(category, forKey: "category")
        NotificationCenter.default.post(name: .categoryDidUpdate, object: nil)
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
