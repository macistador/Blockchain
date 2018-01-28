//
//  Blockchain.swift
//  BabyBlockchain
//
//  Created by Michel-Andre Chirita on 28/01/2018.
//  Copyright © 2018 Croamac. All rights reserved.
//

import Foundation

/*
Remarques
 - on ajoute un block sans vérifier que la proof est correcte
 - on ne vérifie pas les clés des transactions
 */

struct Blockchain {
  private var chain : [Block]
  private var transactionsPool : [Transaction] = []
  var lastBlock : Block? { return chain.last }
  var lenght: Int { return chain.count }
  var numberOfWaitingTransactions: Int { return transactionsPool.count }

  init(with initialChain: [Block]) {
    self.chain = initialChain
  }

  // Ajoute une transaction à la pool
  mutating func addTransactionToPool(_ transaction: Transaction) {
    transactionsPool.append(transaction)
  }

  // Return la nouvelle proof of work à partir de la précédente
  func proofOfWork(lastProof: Int) -> Int {
    var proof = 0
    while !isValid(proof: proof, with: lastProof) { proof += 1 }
    return proof
  }

  // crée un block avec les transactions et y ajoute le hash du block précédent
  // l'ajoute à la chaine
  // puis reset la pool de transactions
  // prk previousHash dans les params?
  // remark: ne vérifie pas si la proof fournie est correcte !
  mutating func addNewBlock(with proof: Int, previousHash: String? = nil) {
    let previousHash = previousHash ?? lastBlockHash(block: chain.last)
    let block = Block(index: chain.count+1, timestamp: Date(), transactions: transactionsPool, proof: proof, previousHash: previousHash)
    chain.append(block)
    resetTransactionsPool()
  }
}


//Mark: Private methods

extension Blockchain {

  // A partir d'un block return son hash
  // sous forme de sha256 en string
  func lastBlockHash(block: Block?) -> String? {
    guard let dataBlock = try? JSONEncoder().encode(block) else {print("L'encodage du block a merdé"); return nil}
    let sha = dataBlock.sha256()
    guard let shaString = String(data: sha, encoding: .utf8) else {print("L'encodage en string du sha a merdé"); return nil}
    return shaString
  }

  fileprivate func isValid(proof: Int, with lastProof: Int) -> Bool {
    let concat = String(proof).appending(String(lastProof))
    guard let sha = shaFrom(concat) else {return false}
    let shaNumber = Int64(sha)
    let isValid = (shaNumber?.trailingZeroBitCount == 4)
    return isValid
  }

  private func shaFrom(_ proof: String) -> String? {
    let proofData = Data(base64Encoded: proof)
    guard let shaData = proofData?.sha256() else { print("L'encodage de la proof a merdé"); return nil}
    guard let shaString = String(data: shaData, encoding: .utf8) else {print("L'encodage en string du sha a merdé"); return nil}
    return shaString
  }

  // Reset les transactions
  private mutating func resetTransactionsPool() {
    transactionsPool = []
  }
}

