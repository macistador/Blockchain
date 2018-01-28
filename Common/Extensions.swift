//
//  Extensions.swift
//  BabyBlockchain
//
//  Created by Michel-Andre Chirita on 28/01/2018.
//  Copyright © 2018 Croamac. All rights reserved.
//

import Foundation

extension Data {
  func sha256() -> Data {
    var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
    self.withUnsafeBytes {
      _ = CC_SHA256($0, CC_LONG(self.count), &hash)
    }
    return Data(bytes: hash)
  }
}
