//
//  FavoriteTableViewCell.swift
//  鐵路時刻表
//
//  Created by 黃暉德 on 2019/1/14.
//  Copyright © 2019 黃暉德. All rights reserved.
//

import UIKit

class FavoriteLineListTableViewCell: UITableViewCell {

    @IBOutlet weak var originStationLabel: UILabel!
    @IBOutlet weak var destinationStationLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
