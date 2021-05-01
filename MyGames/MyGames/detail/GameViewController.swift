//
//  GameViewController.swift
//  MyGames
//
//  Created by Beatriz Castro on 27/04/21.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var ivConsole: UIImageView!
    
    var game: Game!
    
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /// - returns irá setar os dados do game escolhido nos campos da tela de detalhes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbTitle.text = game.title
        lbConsole.text = game.console?.name
        
        if let imageConsole = game.console?.cover as? UIImage {
            ivConsole.image = imageConsole
        } else {
            ivConsole.image = UIImage(named: "noCoverFull")
        }
        
        if let releaseDate = game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            lbReleaseDate.text = "Lançamento: " + formatter.string(from: releaseDate)
        }
        
        if let image = game.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    /// - returns irá passar os dados do game para a tela de edição
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "editGameSegue" {
            let vc = segue.destination as! AddEditViewController
            vc.game = game
            
        }
    }

}
