//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by Beatriz Castro on 27/04/21.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Metodo para fazer o bind de cada campo da celula com os dados do game
    ///
    /// - parameter game: dados do game que será rendenrizado na celula
    /// - returns: fazer o bind de cada campo com os dados do game
    func prepare(with game: Game) {
        
        lbTitle.text = game.title ?? ""
        lbConsole.text = game.console?.name ?? ""
        if let image = game.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCover")
        }
        
    }

}
