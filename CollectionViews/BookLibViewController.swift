//
//  BookLibViewController.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-08.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

//struct LibBook {
//    let title: String 
//    let isbn: String?
//    let key: String?
//    var image: UIImage?
//}
struct LibBook: Equatable {
    let title: String
    let isbn: String?
    let key: String?
    var image: UIImage?

    static func == (lhs: LibBook, rhs: LibBook) -> Bool {
        return lhs.title == rhs.title &&
               lhs.isbn == rhs.isbn &&
               lhs.key == rhs.key
        // The image property is not compared because UIImage does not conform to Equatable
    }
}

class BookLibViewController: UIViewController {

    @IBOutlet weak var BookLibcollectionView: UICollectionView!
    
//    var timer: Timer?
    var books: [LibBook] = []
    let booksqueue = DispatchQueue(label: "com.library.booksLibQueue", attributes: .concurrent)
    let defaultCoverImage = UIImage(named: "agentsOfShield")
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(categoryDidUpdate), name: .categoryDidUpdate, object: nil)
        let category = UserDefaults.standard.string(forKey: "category") ?? "History"
        fetchBooks(category)
        BookLibcollectionView.dataSource = self
        BookLibcollectionView.delegate = self
        BookLibcollectionView.collectionViewLayout = UICollectionViewFlowLayout()

        BookLibcollectionView.decelerationRate = .fast
        BookLibcollectionView.showsVerticalScrollIndicator = false
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(categoryDidUpdate), name: .categoryDidUpdate, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .categoryDidUpdate, object: nil)
    }

    @objc func categoryDidUpdate(_ notification: Notification) {
        // Fetch the new category from UserDefaults
        if let newCategory = UserDefaults.standard.string(forKey: "category") {
            // Update your data source based on the new category
            // This is a placeholder for where you would fetch new data
            fetchBooks(newCategory)
        }
    }
    func fetchBooks(_ category: String) {
        guard let url = URL(string: "https://openlibrary.org/subjects/\(category).json?limit=1000") else { return }
        print(url)
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
//            print(String(data: data, encoding: .ascii)!)
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let works = jsonResult["works"] as? [[String: Any]] {
                    var fetchedBooks: [LibBook] = []
                    for work in works {
                        if let title = work["title"] as? String,
                           let coverEditionKey = work["cover_edition_key"] as? String,
                            let key = work["key"] as? String{
                           let book = LibBook(title: title, isbn: coverEditionKey, key: key)
                            fetchedBooks.append(book)
                        }
                    }
                    DispatchQueue.main.async {
                        
                        self?.books = fetchedBooks.shuffled()
                        self?.updateUI(with: self!.books)
                        self?.BookLibcollectionView.reloadData()
                        self?.fetchBooksCover()
                    }
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }.resume()
    }
     func updateUI(with books: [LibBook]) {
        // Assuming 'booksCollectionView' is your UICollectionView IBOutlet
        self.books = books // Update your data source array
        self.BookLibcollectionView.reloadData() // Reload the collection view
    }


//    func fetchBooksCover() {
//            for (index, book) in books.enumerated() {
//                let coverUrlString = "https://covers.openlibrary.org/b/olid/\(book.isbn)-L.jpg"
//                guard let coverUrl = URL(string: coverUrlString) else { continue }
////                print(coverUrl)
//                URLSession.shared.dataTask(with: coverUrl) { [weak self] data, response, error in
//                    guard let data = data, error == nil else { return }
//
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            self?.books[index].image = image
//                            let indexPath = IndexPath(item: index, section: 0)
//                            self?.BookLibcollectionView.reloadItems(at: [indexPath])
//                        }
//                    }
//                }.resume()
//            }
//        }
    func fetchBooksCover() {
            for (index, books) in books.enumerated() {
               guard let isbn = books.isbn
                else {
                    DispatchQueue.main.async {
                        self.books[index].image = self.defaultCoverImage
                        // Update your collection view or UI here
                        let indexPath = IndexPath(item: index, section: 0)
                        self.BookLibcollectionView.reloadItems(at: [indexPath])
                    }
                    continue
                }
                let coverUrlString = "https://covers.openlibrary.org/b/olid/\(isbn)-L.jpg"
                guard let coverUrl = URL(string: coverUrlString) else {
                    DispatchQueue.main.async {
                        self.books[index].image = self.defaultCoverImage
                        // Update your collection view or UI here
                        let indexPath = IndexPath(item: index, section: 0)
                        self.BookLibcollectionView.reloadItems(at: [indexPath])
                    }
                    continue
                }

                URLSession.shared.dataTask(with: coverUrl) { [weak self] data, response, error in
                    guard let data = data, error == nil else { return }

                    if let image = UIImage(data: data) {
                        self?.booksqueue.async(flags: .barrier) {
                            // Ensure the index is still valid
                            guard index < self?.books.count ?? 0 else { return }
                            self?.books[index].image = image
                            
                            DispatchQueue.main.async {
                                // Update your collection view or UI here
                                let indexPath = IndexPath(item: index, section: 0)
                                self?.BookLibcollectionView.reloadItems(at: [indexPath])
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.books[index].image = self?.defaultCoverImage
                            // Update your collection view or UI here
                            let indexPath = IndexPath(item: index, section: 0)
                            self?.BookLibcollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }.resume()
            }
        }
    //Fuction to call search Button
    @IBAction func PresentSearch(_ sender: Any) {
        let CategoriesViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        CategoriesViewController.modalPresentationStyle = .fullScreen
        CategoriesViewController.delegate = self
        self.present(CategoriesViewController, animated: true, completion: nil)
    }
    @IBAction func refreshBookData(_ sender: Any) {
        print("Buttonclicked")
        if let category = UserDefaults.standard.string(forKey: "category") {
            fetchBooks(category)
            print(category)
        }
    }
}

extension BookLibViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BookLibcollectionView.dequeueReusableCell(withReuseIdentifier: "BookLibcollectionViewCell", for: indexPath) as! BookLibcollectionViewCell
        cell.setup(with: books[indexPath.row])
        return cell
    }
    
}

extension BookLibViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
}

extension BookLibViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        let selectedBook = books[indexPath.row]
        UserDefaults.standard.set(selectedBook.key, forKey: "savedBookKey")
        print(selectedBook.title)
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}

extension BookLibViewController: CategoriesViewControllerDelegate{
    func didUpdateCategory(_ category: String) {
        fetchBooks(category)
    }
    
}
extension Notification.Name {
    static let categoryDidUpdate = Notification.Name("categoryDidUpdate")
}
//extension LibBook: Equatable {
//    static func == (lhs: LibBook, rhs: LibBook) -> Bool {
//        return lhs.title == rhs.title &&
//               lhs.isbn == rhs.isbn &&
//               lhs.key == rhs.key
//        // The image property is not compared because UIImage does not conform to Equatable
//    }
//}


