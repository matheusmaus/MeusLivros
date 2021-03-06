//
//  AddCategoryViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 12/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class AddCategoryViewController: UIViewController, AddCategoryDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var nomeCategoria: UITextField!
    
    @IBOutlet weak var animationCategory: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLottie()
    }
    
    // MARK: - Lottie
    
    func startLottie() {
        
        animationCategory.animation = Animation.named("owl-book")
        animationCategory.loopMode = .loop
        animationCategory.play()
    }
    
    // MARK: - Salvar Categoria

    @IBAction func onSalvar(_ sender: Any) {
        
        let name = self.nomeCategoria.text
        
        if ( name?.count == 0 ) {
            DataSingleton.sharedInstance.toastMessage("Informe o nome da categoria")
            return
        }
        
        DataSingleton.sharedInstance.addCategoryDelegate = self
        DataSingleton.sharedInstance.adicionaCategorias(name!)
        
        Analytics.logEvent("save_category", parameters: [:])
    }
    
    // MARK: - Adicionar Categoria
    
    func onAddCategory(success: Bool) {
        if (success == true) {
            DataSingleton.sharedInstance.toastMessage("Categoria adicionada com sucesso!")
            dismiss(animated: true, completion: nil)
        } else {
            DataSingleton.sharedInstance.toastMessage("Ocorreu um erro ao adicionar categoria")
            dismiss(animated: true, completion: nil)
        }
        
        Analytics.logEvent("add_category", parameters: [:])
    }
}
