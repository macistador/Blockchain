//
//  ViewController.swift
//  Blockchain
//
//  Created by Michel-Andre Chirita on 28/01/2018.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var blockchainLabel: UILabel!
  @IBOutlet weak var wallet1Label: UILabel!
  @IBOutlet weak var wallet2Label: UILabel!

  var wallet1 : Node
  var wallet2 : Node
  var minerNode : Node
  var checkNode : Node

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    wallet1 = Node()
    wallet1.makeBlockchainGenesis()
    let blockchain = wallet1.blockchain

    wallet2 = Node(blockchain: blockchain)
    minerNode = Node(blockchain: blockchain)
    checkNode = Node(blockchain: blockchain)

    wallet1.add([wallet2, minerNode, checkNode])
    wallet2.add([wallet1, minerNode, checkNode])
    minerNode.add([wallet1, wallet2, checkNode])
    checkNode.add([wallet1, minerNode, wallet2])
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    wallet1 = Node()
    wallet1.makeBlockchainGenesis()
    let blockchain = wallet1.blockchain

    wallet2 = Node(blockchain: blockchain)
    minerNode = Node(blockchain: blockchain)
    checkNode = Node(blockchain: blockchain)

    wallet1.add([wallet2, minerNode, checkNode])
    wallet2.add([wallet1, minerNode, checkNode])
    minerNode.add([wallet1, wallet2, checkNode])
    checkNode.add([wallet1, minerNode, wallet2])
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updateLabels()
  }
}


extension ViewController {

  func updateLabels() {
    blockchainLabel.text = String(wallet1.blockchain.lenght)
    wallet1Label.text = String(wallet1.solde)
    wallet2Label.text = String(wallet2.solde)
  }

  @IBAction func addToWallet2Action(_ sender: Any) {
    let transaction = Transaction(sender: wallet1.address, recipient: wallet2.address, amount: 1)
    let newBlockchain = run(transaction, on: wallet2.blockchain)
    if wallet1.update(newBlockchain) == false { print("The other node did not validate the new bc !"); return  }
    updateLabels()
  }

  @IBAction func addToWallet1Action(_ sender: Any) {
    let transaction = Transaction(sender: wallet2.address, recipient: wallet1.address, amount: 1)
    let newBlockchain = run(transaction, on: wallet1.blockchain)
    propagateAndValidate(newBlockchain)
    updateLabels()
  }

  private func run(_ transaction: Transaction, on blockchain: Blockchain) -> Blockchain {
    var blockchain = blockchain
    blockchain.addTransactionToPool(transaction)
    let lastProof = blockchain.lastBlock?.proof ?? 1
    let newProof = blockchain.proofOfWork(lastProof: lastProof)
    blockchain.addNewBlock(with: newProof)
    return blockchain
  }

  private func propagateAndValidate(_ newBlockchain: Blockchain) {
    for node in wallet1.nodes {
      if node.update(newBlockchain) == false { print("The other node did not validate the new bc !"); return }
    }
  }
}



