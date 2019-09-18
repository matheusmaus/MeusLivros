//
//  Categorias.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 07/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import Foundation

struct Categorias {
    var ID: String
    var nomeCategoria: String
    
    init(ID: String, nomeCategoria: String) {
        self.ID = ID
        self.nomeCategoria = nomeCategoria
    }
}
