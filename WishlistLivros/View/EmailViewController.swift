//
//  EmailViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 03/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class EmailViewController: UIViewController, ValidaEmailDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var labelEmail: UITextField!
    @IBOutlet weak var animationEmail: AnimationView!
    
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
        
        animationEmail.animation = Animation.named("dino-dancing")
        animationEmail.loopMode = .loop
        animationEmail.play()
    }
    
    // MARK: - Botão Próximo
    
    @IBAction func onBtnNext(_ sender: Any) {
        let email = self.labelEmail.text
        
        if ( email?.count == 0 ) {
            DataSingleton.sharedInstance.toastMessage("Informe o e-mail")
            
            Analytics.logEvent("email_login_btn", parameters: [:])
            return
    }
        
        DataSingleton.sharedInstance.validaEmailDelegate = self
        DataSingleton.sharedInstance.validaEmail(email!)
    }
    
    // MARK: - Validação para Telas Personalizadas
    
    func onValidaEmail(valido: Bool, emailValido: Bool) {
        if (valido == true && emailValido == true) {
            self.performSegue(withIdentifier: "segueSenha", sender: true)
            Analytics.logEvent("segue_senha", parameters: [:])
            
        } else if (valido == false && emailValido == true) {
            self.performSegue(withIdentifier: "segueNovaConta", sender: true)
            Analytics.logEvent("segue_novaconta", parameters: [:])
            
        } else {
            DataSingleton.sharedInstance.toastMessage("E-mail inválido")
            Analytics.logEvent("email_invalido", parameters: [:])
        }
    }
    
    // MARK: - Encaminhar
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let email = self.labelEmail.text
        if segue.destination is SenhaViewController
        {
            let vc = segue.destination as? SenhaViewController
            vc?.email = email!
        } else if segue.destination is CriarContaViewController {
            let vc = segue.destination as? CriarContaViewController
            vc?.email = email!
        }
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
    
}
