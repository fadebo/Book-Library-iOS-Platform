//
//  AllBookcollectionViewCell.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-07.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

class AllBookcollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var AllbookImageView: UIImageView!
    @IBOutlet weak var AlltitleLbl: UILabel!
    
//    func setup(with movie: Movie) {
//        movieImageView.image = movie.image
//        titleLbl.text = movie.title
//    }
    func setup(with allbook: AllBook) {
        AllbookImageView.image = allbook.image
        AlltitleLbl.text = allbook.title
    }
}
