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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "editConsoleSegue" {
            let vc = segue.destination as! AddEditConsoleViewController
            vc.console = console
            
        }
    }
}
