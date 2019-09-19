//
//  AddBookViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 12/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, AddBookDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var nomeLivro: UITextField!
    @IBOutlet weak var nomeAutor: UITextField!
    @IBOutlet weak var precco: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        let bookName = self.nomeLivro.text
        let author = self.nomeAutor.text
        let price = self.precco.text
        
        if ( bookName?.count == 0 ) {
            DataSingleton.sharedInstance.toastMessage("Informe o nome do livro")
            return
        }
        
        if ( author?.count == 0 ) {
            DataSingleton.sharedInstance.toastMessage("Informe o nome do autor")
            return
        }
        
        if ( price?.count == 0 ) {
            DataSingleton.sharedInstance.toastMessage("Tem certeza que é de graça?")
            return
        }
        
        DataSingleton.sharedInstance.addBookDelegate = self
        DataSingleton.sharedInstance.adicionaLivros (bookName!, autor: author!, preco: price!)
    }
    
    func onAddBook(success: Bool) {
        if (success == true) {
            DataSingleton.sharedInstance.toastMessage("Livro adicionado com sucesso!")
            dismiss(animated: true, completion: nil)
        } else {
            DataSingleton.sharedInstance.toastMessage("Ocorreu um erro ao adicionar seu livro")
            dismiss(animated: true, completion: nil)
        }
    }
}
