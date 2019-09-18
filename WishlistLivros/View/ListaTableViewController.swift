//
//  ListaTableViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 03/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit

class ListaTableViewController: UITableViewController, ReadBookDelegate {
    
    var livros: Array<Livros> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green: 168.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30)
        self.tableView.tableFooterView = spinner
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        DataSingleton.sharedInstance.readBookDelegate = self
        DataSingleton.sharedInstance.retornaLivros();
    }
    
    func onReadBook(success: Bool, livros: Array<Livros>) {
            self.livros = livros
            self.tableView.reloadData()
    }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksDetailsCell", for: indexPath)

            cell.textLabel?.text = livros[indexPath.row].nome
            cell.textLabel?.text = livros[indexPath.row].autor
            cell.textLabel?.text = livros[indexPath.row].preco

            return cell
        }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let count = livros.count
            return count
        }
    
    // Mark: - Table view delegate //Swipes
    
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
            let ignore = deleteAction(at: indexPath)
            return UISwipeActionsConfiguration (actions: [ignore])
        }
    
        func deleteAction (at indexPath: IndexPath) -> UIContextualAction {
    
            let action = UIContextualAction(style: .destructive, title: "Excluir") { (action, view, completion) in
                self.livros.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            }
    
            action.backgroundColor = .red
    
            return action
        }
}
