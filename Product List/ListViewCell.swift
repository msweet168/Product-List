//
//  ListViewCell.swift
//  Product List
//
//  Created by Mitchell Sweet on 1/4/18.
//  Copyright © 2018 Mitchell Sweet. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var id: UILabel!
    @IBOutlet var vendor: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var numVarients: UILabel!
    @IBOutlet var varients: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itemImage.layer.cornerRadius = 15
        itemImage.layer.masksToBounds = true
        itemImage.layer.borderColor = UIColor.themeColor.cgColor
        itemImage.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
