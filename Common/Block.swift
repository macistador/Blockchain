//
//  Block.swift
//  BabyBlockchain
//
//  Created by Michel-Andre Chirita on 28/01/2018.
//  Copyright © 2018 Croamac. All rights reserved.
//

import Foundation

struct Block : Codable {
  var index: Int
  var timestamp: Date
  var transactions: [Transaction]
  var proof: Int // utilisé pour miner le prochain block
  var previousHash: String? // utilisé lier au block précédent
}
