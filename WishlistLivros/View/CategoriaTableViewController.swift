//
//  CategoriaTableViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 03/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit
import Firebase

class CategoriaTableViewController: UITableViewController, ReadCategoryDelegate {
    
    var categorias: Array<Categorias> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green: 168.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor(red: 0.0/255.0, green: 168.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = .black

        let spinner = UIActivityIndicatorView(style: .gray)
        self.tableView.tableFooterView = spinner
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        DataSingleton.sharedInstance.readCategoryDelegate = self
        
    }
    
    @IBAction func profileBtn(_ sender: Any) {
        Analytics.logEvent("profile_button", parameters: [:])
    }
    
    @IBAction func openAddCategoryBtn(_ sender: Any) {
        Analytics.logEvent("open_add_category", parameters: [:])
    }
    
    // MARK: - Alimentar Table View
    
    override func viewWillAppear(_ animated: Bool) {
        DataSingleton.sharedInstance.retornaCategorias()

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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = categorias.count
        return count
    }
    
    // MARK: - Swipes + Excluir
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let ignore = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration (actions: [ignore])
    }

    func deleteAction (at indexPath: IndexPath) -> UIContextualAction {
        
        let categoria = categorias[indexPath.row]

        let action = UIContextualAction(style: .destructive, title: "Excluir") { (action, view, completion) in
            DataSingleton.sharedInstance.deleteCategorias(categoria: categoria)
            self.categorias.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
            
            Analytics.logEvent("swipe_delete_category", parameters: [:])
        }

        action.backgroundColor = .red

        return action
    }
    
    // MARK: - Encaminhar
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListaTableViewController" {
            guard let nav = segue.destination as? UINavigationController else {
                return
            }
            
            guard let vc = nav.viewControllers.first as? ListaTableViewController else {
                return
            }
            
            guard let indexPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            
            let categoria = categorias[indexPath.row]
            
            print(categoria)
            print(categorias)
            
            vc.categoria = categoria
        }
    }
}
