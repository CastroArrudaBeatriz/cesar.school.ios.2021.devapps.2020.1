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
    
    /// Metodo para definir a quantidade de secoes que a TableView terá
    ///
    /// - warning esse metódo tem que retornar sempre 1 o deve ser deletado, se retornar 0 nenhum dado será exibido na sua tabela
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Metodo de apoio para retornar a quantidade de linhas da TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        consolesManager.consoles.count
    }

    /// Metodo de apoio para retornar cada celula da TableView e sua formatação
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
    
    /// Metodo de apoio para controlar as iterações em cada celula da TableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            consolesManager.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   
    /// Metodo executado antes de qualquer navegação de segue desta tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "consoleSegue" {
            let vc = segue.destination as! ConsoleViewController
            vc.console = consolesManager.consoles[tableView.indexPathForSelectedRow!.row]
        }
    }
}
