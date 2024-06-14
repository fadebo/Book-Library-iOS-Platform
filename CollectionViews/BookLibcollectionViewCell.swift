//
//  BookLibcollectionViewCell.swift
//  CollectionViews
//
//  Created by Lab8student on 2024-04-08.
//  Copyright © 2024 Macco. All rights reserved.
//

import UIKit

class BookLibcollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bookLibImagView: UIImageView!
    
    @IBOutlet weak var LibtitleLbl: UILabel!
    func setup(with booklib: LibBook) {
        bookLibImagView.image = booklib.image
        LibtitleLbl.text = booklib.title
    }
}
