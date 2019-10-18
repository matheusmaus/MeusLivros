//
//  AddBookViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 12/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class AddBookViewController: UIViewController, AddBookDelegate {
    
    var categoria: Categorias!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var nomeLivro: UITextField!
    @IBOutlet weak var nomeAutor: UITextField!
    @IBOutlet weak var precco: UITextField!
    
    @IBOutlet weak var animationBook: AnimationView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
        startLottie()
       }
    
    // MARK: - Lottie
    
    func startLottie() {
        
        animationBook.animation = Animation.named("772-bookmark-animation")
        animationBook.loopMode = .loop
        animationBook.play()
    }
    
    // MARK: - Salvar Livro
    
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
        DataSingleton.sharedInstance.adicionaLivros (bookName!, autor: author!, preco: price!, categoria: self.categoria)
    }
    
    // MARK: - Adicionar Livro
    
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
