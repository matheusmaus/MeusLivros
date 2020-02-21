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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailConfimTextFIeld: UITextField!
    @IBOutlet weak var actualEmail: UITextField!
    let currentUser = DataSingleton.sharedInstance.getUser()

  override func viewDidLoad() {
    super.viewDidLoad()
    actualEmail.text = currentUser.email
    nameTextField.text = currentUser.name
  }

  @IBAction func onBtnSave(_ sender: Any) {
    guard
      let name = nameTextField.text,
      let email = labelEmail.text,
      let confirmEmail = emailConfimTextFIeld.text,
      !email.isEmpty,
      email == confirmEmail
      else {
        onUpdateEmail(valido: false)
        return
    }

    let currentUser = DataSingleton.sharedInstance.getUser()

    UserAPI.saveUser(user: User(id: currentUser.id,
                                email: email,
                                name: name))

    DataSingleton.sharedInstance.updateUser(email, name)
    onUpdateEmail(valido: true)
  }

  func onUpdateEmail(valido: Bool) {
    if valido {
        DataSingleton.sharedInstance.toastMessage("E-mail alterado com sucesso")
        dismiss(animated: true, completion: nil)
        Analytics.logEvent("segue_senha", parameters: [:])
    } else {
        DataSingleton.sharedInstance.toastMessage("Não foi possível alterar o e-mail")
        Analytics.logEvent("email_não_alterado", parameters: [:])
    }
  }

  @IBAction func dismiss(_ sender: Any) {
    dismiss(animated: true)
  }
}
