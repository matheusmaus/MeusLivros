//
//  CategoriaTableViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 03/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit

class CategoriaTableViewController: UITableViewController, ReadCategoryDelegate {
    
    var categorias: Array<Categorias> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30)
        self.tableView.tableFooterView = spinner
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        DataSingleton.sharedInstance.readCategoryDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataSingleton.sharedInstance.retornaCategorias();

    }
    
    func onReadCategory(success: Bool, categorias: Array<Categorias>) {
        self.categorias = categorias
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailsCell", for: indexPath)

        cell.textLabel?.text = categorias[indexPath.row].nomeCategoria

        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = categorias.count
        return count
    }
    
//     Mark: - Table view delegate //Swipes
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let ignore = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration (actions: [ignore])
    }

    func deleteAction (at indexPath: IndexPath) -> UIContextualAction {

        let action = UIContextualAction(style: .destructive, title: "Excluir") { (action, view, completion) in
            self.categorias.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        action.backgroundColor = .red

        return action
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pegar o nome do q foi clicado
        print("You selected section: \(indexPath.section)")
        print("You touched row: \(indexPath.row)")
    }

}
