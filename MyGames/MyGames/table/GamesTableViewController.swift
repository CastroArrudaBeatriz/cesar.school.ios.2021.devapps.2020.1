//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Beatriz Castro on 27/04/21.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
    
    var fetchedResultController:NSFetchedResultsController<Game>!
    
    var label : UILabel = {
        let label = UILabel()
        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center
        return label
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertSearchBar()
        
        loadGames()
    }
    
    
    
    /// Metodo para inserir barra de pesquisa na tela de games
    func insertSearchBar(){
        // altera comportamento default que adicionava background escuro sobre a view principal
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
        
        navigationItem.searchController = searchController
        
        // usando extensions
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    
    /// Metodo para listar os games
    ///
    /// - parameter filtering: titulo do game que deseja filtrar na listagem do games
    /// - returns: guardar as listagem dos games salvos no fetchedResultController da classe
    func loadGames(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if !filtering.isEmpty {
            // usando predicate: conjunto de regras para pesquisas
            // contains [c] = search insensitive (nao considera letras identicas)
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
    }

    /// Metodo de apoio para retornar a quantidade de linhas da TableView, se não houver jogos no fetchedResultController da classe será colocar uma label informativa
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let count = fetchedResultController?.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }
    

    /// Metodo de apoio para retornar cada celula da TableView e sua formatação
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
          return cell
        }
             
        cell.prepare(with: game)
        return cell
    }
    
    
    /// Metodo de apoio para controlar as iterações em cada celula da TableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
            
            do {
                try context.save()
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Metodo executado antes de qualquer navegação de segue desta tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "gameSegue" {
            let vc = segue.destination as! GameViewController

            if let games = fetchedResultController.fetchedObjects {
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }

        }
    }

}

extension GamesTableViewController: NSFetchedResultsControllerDelegate {
 
    // sempre que algum objeto for modificado esse metodo sera notificado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
     
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
}

extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadGames()
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadGames(filtering: searchBar.text!)
        tableView.reloadData()
    }
}

