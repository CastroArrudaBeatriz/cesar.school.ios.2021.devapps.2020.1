//
//  ConsoleTableViewCell.swift
//  MyGames
//
//  Created by Beatriz Castro on 30/04/21.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ivConsole: UIImageView!
    @IBOutlet weak var lbConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
