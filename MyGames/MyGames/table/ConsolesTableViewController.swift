//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Beatriz Castro on 27/04/21.
//

import UIKit

class ConsolesTableViewController: UITableViewController {
    
    var consolesManager = ConsolesManager.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsoles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadConsoles()
    }
    
    func loadConsoles(){
        consolesManager.loadConsoles(with: context)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        consolesManager.consoles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConsoleTableViewCell
        let console = consolesManager.consoles[indexPath.row]
        
        cell.lbConsole?.text = console.name
        if let image = console.cover as? UIImage {
            cell.ivConsole.image = image
        } else {
            cell.ivConsole.image = UIImage(named: "noCover")
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            consolesManager.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "consoleSegue" {
            let vc = segue.destination as! ConsoleViewController
            vc.console = consolesManager.consoles[tableView.indexPathForSelectedRow!.row]
        }
    }
}
