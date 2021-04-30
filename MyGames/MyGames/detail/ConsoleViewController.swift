//
//  ConsoleViewController.swift
//  MyGames
//
//  Created by Beatriz Castro on 30/04/21.
//

import UIKit

class ConsoleViewController: UIViewController {
    
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivConsole: UIImageView!
    
    var console: Console!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbName.text = console.name
        
        if let imageConsole = console.cover as? UIImage {
            ivConsole.image = imageConsole
        } else {
            ivConsole.image = UIImage(named: "noCoverFull")
        }
     
    }
    
    
    @IBAction func editConsole(_ sender: Any) {
    }
    
}
