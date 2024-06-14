//
//  BookcollectionViewCell.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-07.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

class BookcollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
//    func setup(with movie: Movie) {
//        movieImageView.image = movie.image
//        titleLbl.text = movie.title
//    }
    func setup(with book: Book) {
        bookImageView.image = book.image
        titleLbl.text = book.title
    }
}
