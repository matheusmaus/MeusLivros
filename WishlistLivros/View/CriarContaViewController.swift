//
//  CriarContaViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 03/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class CriarContaViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var email: String = ""
    
    @IBOutlet weak var labelPass: UITextField!
    
    @IBOutlet weak var animationCriar: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLottie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    // MARK: - Lottie
     
     func startLottie() {
         
         animationCriar.animation = Animation.named("dino-dancing")
         animationCriar.loopMode = .loop
         animationCriar.play()
     }
    
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 176.0/255.0, green: 102.0/255.0, blue: 254.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 99.0/255.0, green: 226.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    // MARK: - Botão Criar Conta
    
    @IBAction func onBtnNewAccount(_ sender: Any) {
        let senha = self.labelPass.text
        
        Analytics.logEvent("nova_conta_btn", parameters: [:])
        
        Auth.auth().createUser(withEmail: email, password: senha!) { (user, error) in
            
            if let error = error, (error as NSError).code == 17008 {
                print(error)
                DataSingleton.sharedInstance.toastMessage("Email inválido")
                
                Analytics.logEvent("nc_email_invalido", parameters: [:])
            }
            else if let error = error {
                DataSingleton.sharedInstance.toastMessage("Erro ao criar o usuário. Talvez ele já exista no banco de dados.")
                print(error)
                
                Analytics.logEvent("nc_email_taken", parameters: [:])
            }
            else {
                DataSingleton.sharedInstance.setLoginDefaults(self.email, senha!)
                self.performSegue(withIdentifier: "segueMain2", sender: true)
                
                Analytics.logEvent("criar_conta_main", parameters: [:])
            }
        }
    }
}
