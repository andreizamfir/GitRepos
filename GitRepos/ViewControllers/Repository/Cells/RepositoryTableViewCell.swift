//
//  RepositoryTableViewCell.swift
//  GitRepos
//
//  Created by Andrei Zamfir on 08/12/2019.
//  Copyright © 2019 Andrei Zamfir. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
