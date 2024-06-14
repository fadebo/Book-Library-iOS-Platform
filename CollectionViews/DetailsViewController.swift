//
//  DetailsViewController.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-08.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

//protocol DetailsViewControllerDelegate: AnyObject{
////    func did
//}
//struct BookDetails: Decodable {
//    let title: String
//    let description: String?
//    let coverID: Int?
//    let authors: [Author]
//
//    struct Author: Decodable {
//        let name: String
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case title
//        case description
//        case coverID = "covers"
//        case authors
//    }
//}
class DetailsViewController: UIViewController {

    @IBOutlet weak var DetailImageView: UIImageView!
    
    @IBOutlet weak var DetailsTitleLbl: UILabel!
    @IBOutlet weak var DetailAuthor: UILabel!
    @IBOutlet weak var DetailDescription: UITextView!
    
    @IBOutlet weak var BookmarkIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        updateUIWithBookDetails()
        //        let savedBookTitle = UserDefaults.standard.string(forKey: "selectedBookTitle")
        guard let savedBookKey = UserDefaults.standard.string(forKey: "savedBookKey") else { return }
        
        //        self.DetailsTitleLbl.text = "\(savedBookTitle ?? "")"
        print(savedBookKey) // Print the book title or any other details
        fetchBookDetails(workKey: savedBookKey)
    }
    func fetchBookDetails(workKey: String) {
        let urlString = "https://openlibrary.org\(workKey).json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            print(String(data: data, encoding: .ascii)!)
            
            do {
                // Decode the JSON data into a dictionary
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let authorsArray = json["authors"] as? [[String: Any]] {
                    // Extract the author key from the nested dictionaries
                    let authorKeys = authorsArray.compactMap { authorDict in
                        if let author = authorDict["author"] as? [String: Any],
                           let key = author["key"] as? String {
                            return key.replacingOccurrences(of: "/authors/", with: "")
                        }
                        return nil
                    }
                    // Now you have the authorKeys, you can fetch author names using them
                    if let firstAuthorKey = authorKeys.first {
                        self?.fetchAuthorName(authorKey: firstAuthorKey)
                    }
                        DispatchQueue.main.async {
                            // Extract the title and description and update the UI
                            self?.DetailsTitleLbl.text = json["title"] as? String ?? "Title not available"
                            
                            self?.DetailDescription.text = json["description"] as? String ?? "Description not available"
                            //                        let authors = json["authors"] as? [[String: Any]]
                            //                        self?.DetailAuthor.text = authors?.first?["name"] as? String ?? "Author not available"
                            // Assuming each author has a 'key' in the dictionary
                            //                        let authorKeys = authors?.compactMap { $0["key"] as? String }
                            print(authorKeys)
                            if let coverId = json["covers"] as? [Int] {
                                self?.DetailImageView.loadImageFromUrl("https://covers.openlibrary.org/b/id/\(coverId[0])-M.jpg")
                            }
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}

extension UIImageView {
    func loadImageFromUrl(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
extension DetailsViewController {
    func fetchAuthorName(authorKey: String) {
        guard let url = URL(string: "https://openlibrary.org/authors/\(authorKey).json") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            do {
                // Parse the JSON data manually
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let authorName = jsonResult["name"] as? String {
                    DispatchQueue.main.async {
                        self?.DetailAuthor.text = "Author: \(authorName)"
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

