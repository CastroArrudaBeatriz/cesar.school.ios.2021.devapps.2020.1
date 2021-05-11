//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Douglas Frari on 4/29/21.
//

import Foundation

import CoreData

class ConsolesManager {
 
    static let shared = ConsolesManager()
    var consoles: [Console] = []
    
    /// Metodo para listar os consoles
    ///
    /// - returns: guardar o fetch de consoles gravados no banco local, dentro da variavel 'consoles'
    func loadConsoles(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
     
        do {
            consoles = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
 
    /// Metodo para remover console
    ///
    /// - returns: deleta o console gravado no banco local  e remove do array 'consoles'
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
     
        do {
            try context.save()
            // tirar da lista local de consoles para manter a estrutura dos dados atualizados
            consoles.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
 
    private init() {
     
    }
}
