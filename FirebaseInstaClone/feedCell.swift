//
//  feedCell.swift
//  FirebaseInstaClone
//
//  Created by Atil Samancioglu on 6.10.2018.
//  Copyright © 2018 Atil Samancioglu. All rights reserved.
//

import UIKit

class feedCell: UITableViewCell {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
