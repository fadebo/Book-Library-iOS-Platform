//
//  ViewController.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-08.
//  Copyright © 2024 Macco. All rights reserved.
//


import UIKit

struct Book {
    let title: String
    let isbn: String?
    let key: String?
    var image: UIImage?
}

struct AllBook {
    let title: String
    let isbn: String?
    let key: String?
    var image: UIImage?
}

class ViewController: UIViewController{

    @IBOutlet weak var BookcollectionView: UICollectionView!
    @IBOutlet weak var AllBookcollectionView: UICollectionView!
    var books: [Book] = []
    var allbooks: [AllBook] = []
    let queue = DispatchQueue(label: "com.library.Queue", attributes: .concurrent)
    let booksqueue = DispatchQueue(label: "com.library.booksQueue", attributes: .concurrent)
    let defaultCoverImage = UIImage(named: "agentsOfShield")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        if(!isUserLoggedIn){
            let loginView = (self.storyboard?.instantiateViewController(identifier: "WelcomePageViewController"))!
            loginView.navigationItem.hidesBackButton = true
            
            self.navigationController?.pushViewController(loginView, animated: true)
        }else{
            let subjects = ["art", "fiction", "biology", "chemistry", "physics", "programming", "maths", "finance", "archaeology", "psychology"]
            fetchBooks(forSubjects: subjects)
            fetchAllBooks(forSubjects: subjects)
            BookcollectionView.dataSource = self
            AllBookcollectionView.dataSource = self
            BookcollectionView.delegate = self
            AllBookcollectionView.delegate = self
            BookcollectionView.collectionViewLayout = UICollectionViewFlowLayout()
            AllBookcollectionView.collectionViewLayout = UICollectionViewFlowLayout()
            
            BookcollectionView.decelerationRate = .fast
            AllBookcollectionView.decelerationRate = .fast
            BookcollectionView.showsHorizontalScrollIndicator = false
            AllBookcollectionView.showsVerticalScrollIndicator = false
            
            if let layout = BookcollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.itemSize = CGSize(width: 120, height: 200) // Adjust the size as needed
            }
            if let layout = AllBookcollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
                layout.itemSize = CGSize(width: 120, height: 200) // Adjust the size as needed
            }
        }
        

    }

    func fetchBooks(forSubjects subjects: [String]) {
        let session = URLSession.shared
        let baseURL = "https://openlibrary.org/subjects/"
        
        for subject in subjects {
            let urlString = "\(baseURL)\(subject).json?limit=20"
            guard let url = URL(string: urlString) else { continue }
            
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let works = jsonResult["works"] as? [[String: Any]] {
                        var fetchedBooks: [Book] = []
                        for work in works {
                            if let title = work["title"] as? String,
                               let coverEditionKey = work["cover_edition_key"] as? String,
                                let key = work["key"] as? String{
                               let book = Book(title: title, isbn: coverEditionKey, key: key)
                                fetchedBooks.append(book)
                            }
                        }
                        DispatchQueue.main.async {
                            self.books = fetchedBooks.shuffled();                       self.BookcollectionView.reloadData()
                            self.fetchBooksCover()
                        }
                    }
                } catch {
                    print("Failed to decode JSON for subject: \(subject)")
                }
            }
            task.resume()
        }
    }

    func fetchBooksCover() {
            for (index, books) in books.enumerated() {
               guard let isbn = books.isbn
                else {
                    DispatchQueue.main.async {
                        self.books[index].image = self.defaultCoverImage
                        // Update your collection view or UI here
                        let indexPath = IndexPath(item: index, section: 0)
                        self.BookcollectionView.reloadItems(at: [indexPath])
                    }
                    continue
                }
                let coverUrlString = "https://covers.openlibrary.org/b/olid/\(isbn)-L.jpg"
                guard let coverUrl = URL(string: coverUrlString) else {
                    DispatchQueue.main.async {
                        self.books[index].image = self.defaultCoverImage
                        // Update your collection view or UI here
                        let indexPath = IndexPath(item: index, section: 0)
                        self.BookcollectionView.reloadItems(at: [indexPath])
                    }
                    continue
                }

                URLSession.shared.dataTask(with: coverUrl) { [weak self] data, response, error in
                    guard let data = data, error == nil else { return }

                    if let image = UIImage(data: data) {
                        self?.queue.async(flags: .barrier) {
                            // Ensure the index is still valid
                            guard index < self?.books.count ?? 0 else { return }
                            self?.books[index].image = image
                            
                            DispatchQueue.main.async {
                                // Update your collection view or UI here
                                let indexPath = IndexPath(item: index, section: 0)
                                self?.BookcollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.books[index].image = self?.defaultCoverImage
                            // Update your collection view or UI here
                            let indexPath = IndexPath(item: index, section: 0)
                            self?.BookcollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }.resume()
            }
        }

    func fetchAllBooks(forSubjects subjects: [String]) {
        let session = URLSession.shared
        let baseURL = "https://openlibrary.org/subjects/"
        
        for subject in subjects {
            let urlString = "\(baseURL)\(subject).json?limit=400"
            guard let url = URL(string: urlString) else { continue }
            
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let works = jsonResult["works"] as? [[String: Any]] {
                        var fetchedAllBooks: [AllBook] = []
                        for work in works {
                            if let title = work["title"] as? String,
                               let coverEditionKey = work["cover_edition_key"] as? String,
                                let key = work["key"] as? String{
                               let books = AllBook(title: title, isbn: coverEditionKey, key: key)
                                fetchedAllBooks.append(books)
                            }
                        }
                        DispatchQueue.main.async {
                            self.allbooks = fetchedAllBooks.shuffled();                          self.AllBookcollectionView.reloadData()
                            self.fetchAllBooksCover()
                        }
                    }
                } catch {
                    print("Failed to decode JSON for subject: \(subject)")
                }
            }
            task.resume()
        }
    }

    func fetchAllBooksCover() {
            for (index, books) in allbooks.enumerated() {
               guard let isbn = books.isbn
                else {
                    DispatchQueue.main.async {
                        self.allbooks[index].image = self.defaultCoverImage
                        // Update collection view or UI here
                        let indexPath = IndexPath(item: index, section: 0)
                        self.AllBookcollectionView.reloadItems(at: [indexPath])
                    }
                    continue
                }
                let coverUrlString = "https://covers.openlibrary.org/b/olid/\(isbn)-L.jpg"
                guard let coverUrl = URL(string: coverUrlString) else {
                    DispatchQueue.main.async {
                        self.allbooks[index].image = self.defaultCoverImage
                        // Update collection view or UI here
                        let indexPath = IndexPath(item: index, section: 0)
                        self.AllBookcollectionView.reloadItems(at: [indexPath])
                    }
                    continue
                }

                URLSession.shared.dataTask(with: coverUrl) { [weak self] data, response, error in
                    guard let data = data, error == nil else { return }

                    if let image = UIImage(data: data) {
                        self?.booksqueue.async(flags: .barrier) {
                            // Ensure the index is still valid
                            guard index < self?.allbooks.count ?? 0 else { return }
                            self?.allbooks[index].image = image
                            
                            DispatchQueue.main.async {
                                // Update collection view or UI here
                                let indexPath = IndexPath(item: index, section: 0)
                                self?.AllBookcollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
//                            self?.allbooks[index].image = self?.defaultCoverImage
                            // Update collection view or UI here
                            let indexPath = IndexPath(item: index, section: 0)
                            self?.AllBookcollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }.resume()
            }
        }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == AllBookcollectionView {
            return allbooks.count
        } else if collectionView == BookcollectionView {
            return books.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == AllBookcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllBookcollectionViewCell", for: indexPath) as! AllBookcollectionViewCell
            cell.setup(with: allbooks[indexPath.row])
            return cell
        } else if collectionView == BookcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookcollectionViewCell", for: indexPath) as! BookcollectionViewCell
            cell.setup(with: books[indexPath.row])
            return cell
        }
        fatalError("Unexpected collection view")
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == AllBookcollectionView {
            // Return size for AllBookCollectionView items
            return CGSize(width: 100, height: 200)
        } else if collectionView == BookcollectionView {
            // Return size for BookCollectionView items
            return CGSize(width: 100, height: 180) // Assuming different size for demonstration
        }
        return CGSize.zero // Default case
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 2 // Replace with desired spacing
        }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
     
        
        if collectionView == AllBookcollectionView {
            // Handle selection for AllBookCollectionView
            let selectedBook = allbooks[indexPath.row]
            UserDefaults.standard.set(selectedBook.key, forKey: "savedBookKey")
            // Encode the selected book
//            if let encodedData = try? JSONEncoder().encode(selectedBook) {
//                // Save the encoded book to UserDefaults
//                UserDefaults.standard.set(selectedBook, forKey: "selectedBook")
//            }
            print(selectedBook.title)
        } else if collectionView == BookcollectionView {
            // Handle selection for BookCollectionView
            let selectedBook = books[indexPath.row]
            UserDefaults.standard.set(selectedBook.key, forKey: "savedBookKey")
            print(selectedBook.title)
        }
        
        // Present DetailsViewController
//                let DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
//        DetailsViewController.navigationController?.pushViewController(DetailsViewController, animated: true)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
//extension DetailsViewController: DetailsViewControllerDelegate{
//    func PresentDetails(){
//        let DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
//        DetailsViewController.modalPresentationStyle = .fullScreen
//        DetailsViewController.delgate = self
//        self.present(DetailsViewController, animated: true, completion: nil)
//    }
//}

