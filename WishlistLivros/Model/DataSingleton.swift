//
//  DataSingleton.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 06/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase

protocol ValidaEmailDelegate: class {
    func onValidaEmail(valido: Bool, emailValido: Bool)
}

protocol ValidaEmailSenhaDelegate: class {
    func onValidaEmailSenha(valido: Bool)
}

//protocol LogoutDelegate: class {
//    func onLogout(valido: Bool)
//}

protocol AddCategoryDelegate: class {
    func onAddCategory(success: Bool)
}

protocol ReadCategoryDelegate: class {
    func onReadCategory(success: Bool, categorias: Array<Categorias>)
}

protocol AddBookDelegate: class {
    func onAddBook(success: Bool)
}

protocol ReadBookDelegate: class {
    func onReadBook(success: Bool, livros: Array<Livros>)
}

class DataSingleton {
    
    var validaEmailDelegate: ValidaEmailDelegate!
    var validaEmailSenhaDelegate: ValidaEmailSenhaDelegate!
    var addCategoryDelegate: AddCategoryDelegate!
    var readCategoryDelegate: ReadCategoryDelegate!
    var addBookDelegate: AddBookDelegate!
    var readBookDelegate: ReadBookDelegate!
    
//    var logoutDelegate: LogoutDelegate!
    
    private let storedEmail = "email"
    private let storedPassword = "senha"
    
    static let sharedInstance = DataSingleton()
    public init() {}
    
    func toastMessage(_ message: String){
        guard let window = UIApplication.shared.keyWindow else {return}
        let messageLbl = UILabel()
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: 12)
        messageLbl.textColor = .white
        messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let textSize:CGSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, window.frame.width - 40)
        
        messageLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
        messageLbl.center.x = window.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height/2
        messageLbl.layer.masksToBounds = true
        window.addSubview(messageLbl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            UIView.animate(withDuration: 1, animations: {
                messageLbl.alpha = 0
            }) { (_) in
                messageLbl.removeFromSuperview()
            }
        }
    }
    
    func validaEmail(_ email: String) {
        let this = self;
        Auth.auth().signIn(withEmail: email, password: " ") { (user, error) in
            if let error = error, (error as NSError).code == 17009 {
                DispatchQueue.main.async {
                    this.validaEmailDelegate.onValidaEmail(valido: true, emailValido: true)
                }
            }
            if let error = error, (error as NSError).code == 17008 {
                DispatchQueue.main.async {
                    this.validaEmailDelegate.onValidaEmail(valido: false, emailValido: false)
                }
            }
            else {
                DispatchQueue.main.async {
                    this.validaEmailDelegate.onValidaEmail(valido: false, emailValido: true)
                }
            }
        }
    }
    
    func validaEmailSenha(_ email: String, _ senha: String) {
        let this = self;
        
        Auth.auth().signIn(withEmail: email, password: senha) { (user, error) in
            
            
            
            if error != nil {
                DispatchQueue.main.async {
                    this.validaEmailSenhaDelegate.onValidaEmailSenha(valido: false)
                }
            } else {
                let defaults = UserDefaults.standard
                defaults.set(user?.user.uid, forKey: "uid")
                
                self.setLoginDefaults(email, senha)
                DispatchQueue.main.async {
                    this.validaEmailSenhaDelegate.onValidaEmailSenha(valido: true)
                }
            }
        }
    }
    
    public func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: self.storedEmail)
        defaults.removeObject(forKey: self.storedPassword)
    }
    
    public func setLoginDefaults(_ email: String, _ senha: String) {
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: self.storedEmail)
        defaults.set(senha, forKey: self.storedPassword)
        
    }
    
    public func getLoginDefaults() -> Login {
        let defaults = UserDefaults.standard
        if let email: String = defaults.string(forKey: self.storedEmail) {
            if let senha: String = defaults.string(forKey: self.storedPassword) {
                var res = Login()
                res.email = email
                res.senha = senha

                return res
            }
        }

        return Login()
    }
    
    func adicionaCategorias(_ categoryName: String) {

        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        db.collection("\(uid)").addDocument(data:[
            "nome": categoryName
        ]) {

            (error:Error?) in
            if error != nil {
                self.addCategoryDelegate.onAddCategory(success: false)
            } else {
                self.addCategoryDelegate.onAddCategory(success: true)

            }
        }
    }

    func retornaCategorias() {

        var categorias = Array<Categorias>()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        
        db.collection("\(uid)").getDocuments {(snapshot, err) in
            if let err = err {
                self.readCategoryDelegate.onReadCategory(success: false, categorias: Array<Categorias>())
            } else {

                for document in snapshot!.documents{
                    let ID = document.documentID as String
                    let nomeCategoria = document.get("nome") as! String

                    let categoria = Categorias(ID: ID, nomeCategoria: nomeCategoria)
                    categorias.append(categoria)
                }

                self.readCategoryDelegate.onReadCategory(success: true, categorias: categorias)
            }
        }
    }
    
    func adicionaLivros(_ nome: String, autor: String, preco: String) {
        
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        /*
        db.collection("\(uid)").document(categoria).addDocument(data: [
            
            "nome": nome,
            "autor": autor,
            "preco": preco
            
        ]) {
            
            (error:Error?) in
            if error != nil {
                self.addBookDelegate.onAddBook(success: false)
            } else {
                self.addBookDelegate.onAddBook(success: true)
                
            }
        }*/
    }
    
    func retornaLivros() {
        
        var livros = Array<Livros>()
         /*
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
         db.collection("\(uid)").document(categoria).getDocument(completion: <#T##FIRDocumentSnapshotBlock##FIRDocumentSnapshotBlock##(DocumentSnapshot?, Error?) -> Void#>) {(snapshot, err) in
            if let err = err {
                self.readBookDelegate.onReadBook(success: false, livros: Array<Livros>())
            } else {
                
                for document in snapshot!.documents{
                    let ID = document.documentID as! String
                    let nome = document.get("nome") as! String
                    let autor = document.get("autor") as! String
                    let preco = document.get("preco") as! String
                    
                    
                    let livro = Livros(ID: ID, nome: nome, autor: autor, preco: preco)
                    livros.append(livro)
                }
                
                self.readBookDelegate.onReadBook(success: true, livros: livros)
            }
        }*/
    }
}