//
//  web3go.swift
//  web3go
//
//  Created by 域乎 on 2019/3/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Geth

@objc(web3go)
class web3go: NSObject {
  private let client = GethNewEthereumClient("http://127.0.0.1:8545", nil)
  private let ctx = GethNewContext()
  
  // generate wallet
  @objc
  func generateWallet(_ callback: RCTResponseSenderBlock) {
    let priv:GethPrivateKey! = GethGenerateKey(nil)
    let privBytes = GethFromECDSA(priv)
    let priv_key = GethEncode(privBytes)
    let pub:GethPublicKey! = priv?.public()
    let pubBytes = GethFromECDSAPub(pub)
    let pub_key = GethEncode(pubBytes)
    let address:GethAddress! = GethPubkeyToAddress(pub)
    
    let result = "\(address.getHex()!)&&\(priv_key!)&&\(pub_key!)"
    callback([result])
  }
  
  // getBalance
  @objc
  func getBalance(_ address: String, callback: RCTResponseSenderBlock) {
    let address = GethNewAddressFromHex(address, nil)
    var ammount :GethBigInt!
    do {
      try ammount = client?.getBalanceAt(ctx, account: address, number: -1)
      callback([ammount.getString(10)])
    } catch {
      callback(["error"])
    }
    
    
  }
  
  //  sendTransaction
  @objc
  func sendTransaction(_ privateKey: String, toAddress: String, callback: RCTResponseSenderBlock) {
    let toAdd = GethNewAddressFromHex(toAddress, nil)
    let priKey = GethHexToECDSA(privateKey, nil)
    let pubKey = priKey?.public()
    let fromAddess = GethPubkeyToAddress(pubKey)
    
    let nonce = UnsafeMutablePointer<Int64>.allocate(capacity: 1)
    nonce.pointee = 20
    var sendAction: ()?
    do {
      try client?.getPendingNonce(at: ctx, account: fromAddess, nonce:nonce)
      //      callback([nonce.pointee])
      let value = GethNewBigInt(10003400000201000)
      let gasLimit = Int64(21000)
      let gasPrice = GethNewBigInt(30000000000)
      
      let data = Data()
      let tx = GethNewTransaction(nonce.pointee, toAdd, value, gasLimit, gasPrice, data)
      let signedTx = GethSignTx(tx, GethNewHomesteadSigner(), priKey, nil)
      try sendAction = client?.sendTransaction(ctx, tx: signedTx)
      //      result = signedTx?.getHash()?.getHex()
      //      callback([sendAction])
      callback([signedTx?.getHash()?.getHex()])
    } catch {
      callback(["error"])
    }
  }
  
  //  getBlockByNumber
  @objc
  func getBlockByNumber(_ bclokNumber: Int64, callback: RCTResponseSenderBlock) {
    var block :GethBlock!
    do {
      try block = client?.getBlockByNumber(ctx, number: bclokNumber)
      let blockNumber = block.getNumber()
      let blockGasLimit = block.getGasLimit()
      let blockGasUsed = block.getGasUsed()
      let blockInt64 = block.getDifficulty()?.getInt64()
      let blockTime = block.getTime()
      let blockMixDigestHex = block.getMixDigest()?.getHex()
      let blockNonce = block.getNonce()
      let blockCoinbaseHex = block.getCoinbase()?.getHash()
      let blockRootHex = block.getRoot()?.getHex()
      let blockHashHex = block.getHash()?.getHex()
      let blockTransactionsSize = block.getTransactions()?.size()
      
      let blockInfo = "\(blockNumber)&&\(blockGasLimit)&&\(blockGasUsed)&&\(blockInt64!)&&\(blockTime)&&\(blockMixDigestHex!)&&\(blockNonce)&&\(blockCoinbaseHex!)&&\(blockRootHex!)&&\(blockHashHex!)&&\(blockTransactionsSize!)"
      callback([blockInfo])
    } catch {
      callback(["error"])
    }
  }
  
  @objc
  func getTransactionsWithHash(_ hash: String, callback: RCTResponseSenderBlock) {
    let txHash = GethNewHashFromHex(hash, nil)
    var tx :GethTransaction!
    do {
      try tx = client?.getTransactionByHash(ctx, hash: txHash)
      let hash = tx.getHash()?.getHex()
      let value = tx.getValue()
      let gas = tx.getGas()
      let gasPrise = tx.getGasPrice()
      let nonce = tx.getNonce()
      let data = tx.getData()
      let to = tx.getTo()?.getHex()
      let signHash = tx.getSigHash()?.getHex()
      
      let result = "\(hash!)&&\(value ?? nil)&&\(gas)&&\(gasPrise ?? nil)&&\(nonce)&&\(data ?? nil)&&\(to!)&&\(signHash!)"
      callback([result])
    } catch {
      callback(["error"])
    }
  }
  
  @objc
  func getTransactionReceipt(_ hash: String, callback: RCTResponseSenderBlock) {
    let txHash = GethNewHashFromHex(hash, nil)
    var tx :GethTransaction!
    var receipt: GethReceipt!
    do {
      try tx = client?.getTransactionByHash(ctx, hash: txHash)
      let hash :GethHash! = tx.getHash()
      try receipt = client?.getTransactionReceipt(ctx, hash: hash)
      callback([receipt.getStatus()])
    } catch {
      callback(["error"])
    }
  }
  
}
