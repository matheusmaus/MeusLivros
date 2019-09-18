//
//  Livros.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 07/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import Foundation

struct Livros {
    var ID: String
    var nome: String
    var autor: String
    var preco: String
    
    init(ID: String, nome: String, autor: String, preco: String) {
        self.ID = ID
        self.nome = nome
        self.autor = autor
        self.preco = preco
    }
}
