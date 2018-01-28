//
//  Wallet.swift
//  BabyBlockchain
//
//  Created by Michel-Andre Chirita on 28/01/2018.
//  Copyright © 2018 Croamac. All rights reserved.
//

import Foundation

protocol Wallet {
  var address: String  {get}
  var solde: Int {get set}
}

protocol Nodable {
  var address: String  {get}
  var blockchain: Blockchain {get set}
  var nodes: [Node]  {get set}
}

class Node: Nodable, Wallet {
  let address: String = UUID().uuidString
  var solde: Int = 0
  var blockchain: Blockchain
  var nodes: [Node]

  init(blockchain: Blockchain? = nil, nodes: [Node]? = nil) {
  self.blockchain = blockchain ?? Blockchain(with: [])
    self.nodes = nodes ?? []
  }

  func makeBlockchainGenesis() {
    guard blockchain.lenght == 0 else { print("La bc doit être vide pour faire le block genesis!"); return }
    let transaction = Transaction(sender: self.address, recipient: self.address, amount: 50)
    let blockGenesis = Block(index: 0, timestamp: Date(), transactions: [transaction], proof: 0, previousHash: nil)
    self.blockchain = Blockchain(with: [blockGenesis])
    solde = 50
  }

  func add(_ nodes: [Node]) {
    self.nodes.append(contentsOf: nodes)
  }

  func update(_ bc: Blockchain) -> Bool {
    guard validateBlockchain(bc) else { print("La blockchain fournie n'est pas valide"); return false}
    blockchain = bc
    return true
  }

  /// Vérifie une nouvelle blockchain par par rapport à la courante
  /// Tous les blocs doivent être identiques
  /// La nouvelle doit être + longue
  /// Les nouveaux blocks doivent bien avoir la proof des précédents
  /// Les transactions qu'ils contiennent doivent être valides (comment?)
  /// TODO...
  private func validateBlockchain(_ bc: Blockchain) -> Bool {
    return true
  }
}
