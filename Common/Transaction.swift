//
//  Transaction.swift
//  BabyBlockchain
//
//  Created by Michel-Andre Chirita on 28/01/2018.
//  Copyright © 2018 Croamac. All rights reserved.
//

import Foundation

typealias WalletAddress = String

struct Transaction: Codable {
  let sender: WalletAddress
  let recipient: WalletAddress
  let amount: Double
}
