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

protocol LogoutDelegate: class {
    func onLogout(valido: Bool)
}

protocol AddCategoryDelegate: class {
    func onAddCategory(success: Bool)
}

protocol ReadCategoryDelegate: class {
    func onReadCategory(success: Bool, categorias: Array<Categorias>)
}

protocol DeleteCategoryDelegate: class {
    func onDeleteCategory(success: Bool, categorias: Array<Categorias>)
}

protocol AddBookDelegate: class {
    func onAddBook(success: Bool)
}

protocol ReadBookDelegate: class {
    func onReadBook(success: Bool, livros: Array<Livros>)
}

protocol DeleteBookDelegate: class {
    func onDeleteBook(success: Bool, livros: Array<Livros>)
}

class DataSingleton {
    
    var validaEmailDelegate: ValidaEmailDelegate!
    var validaEmailSenhaDelegate: ValidaEmailSenhaDelegate!
    
    var addCategoryDelegate: AddCategoryDelegate!
    var readCategoryDelegate: ReadCategoryDelegate!
    var deleteCategoryDelegate: DeleteCategoryDelegate!
    
    var addBookDelegate: AddBookDelegate!
    var readBookDelegate: ReadBookDelegate!
    var deleteBookDelegate: DeleteBookDelegate!
    
    var logoutDelegate: LogoutDelegate!
    
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
    
    // MARK: - Valida eMail
    
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
    
    // MARK: - Valida Senha
    
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
    
    // MARK: - Logout
    
    public func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: self.storedEmail)
        defaults.removeObject(forKey: self.storedPassword)
    }
    
    // MARK: - Login Defaults
    
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
    
    // MARK: - Add Categoria
    
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
    
    // MARK: - Retorna Categoria

    func retornaCategorias() {

        var categorias = Array<Categorias>()
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        
        db.collection("\(uid)").getDocuments {(snapshot, err) in
            if let err = err {
                print(err)
                self.readCategoryDelegate.onReadCategory(success: false, categorias: Array<Categorias>())
            } else {

                for document in snapshot!.documents{
                    let ID = document.documentID
                    let nomeCategoria = document.get("nome") as! String

                    let categoria = Categorias(ID: ID, nomeCategoria: nomeCategoria)
                    categorias.append(categoria)
                }

                self.readCategoryDelegate.onReadCategory(success: true, categorias: categorias)
            }
        }
    }
    
    // MARK: - Delete Categoria
    
    func deleteCategorias(categoria: Categorias) {
        
        //var categorias = Array<Categorias>()
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        
        let categoriaId = categoria.ID
        
        db.collection("\(uid)").document(categoriaId).delete()
        
    }
    
    // MARK: - Add Livro
    
    func adicionaLivros(_ nome: String, autor: String, preco: String, categoria: Categorias) {
        
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let categoriaId = categoria.ID
        let data = [
            "nome": nome,
            "autor": autor,
            "preco": preco
        ]
        
        db.collection("\(uid)").document(categoriaId).collection("livros").addDocument(data: data) {
            (error:Error?) in
            if error != nil {
                self.addBookDelegate.onAddBook(success: false)
            } else {
                self.addBookDelegate.onAddBook(success: true)
                
            }
        }
        
        //db.collection("\(uid)").document(categoriaId).collection("livros").document("").delete()
    }
    
    // MARK: - Retorna Livro
    
    func retornaLivros(categoria: Categorias) {
        
        var livros = Array<Livros>()
        
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let categoriaId = categoria.ID
        
        db.collection("\(uid)").document(categoriaId).collection("livros").getDocuments {(snapshot, err) in
            if let err = err {
                print(err)
                self.readBookDelegate.onReadBook(success: false, livros: Array<Livros>())
            } else {
                
                for document in snapshot!.documents{
                    let ID = document.documentID
                    let nome = document.get("nome") as! String
                    let autor = document.get("autor") as! String
                    let preco = document.get("preco") as! String
                    
                    let livro = Livros(ID: ID, nome: nome, autor: autor, preco: preco)
                    livros.append(livro)
                }
                
                self.readBookDelegate.onReadBook(success: true, livros: livros)
            }
        }
    }
    
    // MARK: - Delete Livro
    
    func deleteLivros(categoria: Categorias, livro: Livros) {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        
        let categoriaId = categoria.ID
        let livroId = livro.ID
        db.collection("\(uid)").document(categoriaId).collection("livros").document(livroId).delete()
        
    }
}
