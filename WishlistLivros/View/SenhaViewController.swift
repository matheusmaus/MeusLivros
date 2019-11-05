//
//  SenhaViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 03/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class SenhaViewController: UIViewController, ValidaEmailSenhaDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var email: String = ""
    
    @IBOutlet weak var labelSenha: UITextField!
    
    @IBOutlet weak var senhaAnimation: AnimationView!
    
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
        
        senhaAnimation.animation = Animation.named("dino-dancing")
        senhaAnimation.loopMode = .loop
        senhaAnimation.play()
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
    
    // MARK: - Botão Login
    
    @IBAction func onBtnEntrar(_ sender: Any) {
        let senha = self.labelSenha.text
        
        Analytics.logEvent("conta_existente_btn", parameters: [:])
        
        DataSingleton.sharedInstance.validaEmailSenhaDelegate = self
        DataSingleton.sharedInstance.validaEmailSenha(email, senha!)
        
    }
    
    // MARK: - Valida Login
    
    func onValidaEmailSenha(valido: Bool) {
        let senha = self.labelSenha.text
        if (!valido) {
            DataSingleton.sharedInstance.toastMessage("E-mail/senha incorretos")
            Analytics.logEvent("ce_email_invalido", parameters: [:])
            
        } else {
            DataSingleton.sharedInstance.setLoginDefaults(self.email, senha!)
            self.performSegue(withIdentifier: "segueMain", sender: true)
            
            Analytics.logEvent("entrar_main", parameters: [:])
        }
    }
}

