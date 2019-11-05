//
//  EditProfileViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 19/10/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UpdateEmailDelegate {
    
    @IBOutlet weak var labelEmail: UITextField!
    
    
    @IBAction func onBtnSave(_ sender: Any) {
        
        _ = self.labelEmail.text
        
        
    }
    
    
    
    func onUpdateEmail(valido: Bool) {
        
        if (valido == true) {
            DataSingleton.sharedInstance.toastMessage("E-mail alterado com sucesso")
             dismiss(animated: true, completion: nil)
             Analytics.logEvent("segue_senha", parameters: [:])
             
         } else {
             DataSingleton.sharedInstance.toastMessage("Não foi possível alterar o e-mail")
            dismiss(animated: true, completion: nil)
             Analytics.logEvent("email_não_alterado", parameters: [:])
         }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
