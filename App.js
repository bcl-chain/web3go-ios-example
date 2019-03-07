/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 * @lint-ignore-every XPLATJSCOPYRIGHT1
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, NativeModules, Button} from 'react-native';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

console.disableYellowBox = true;

type Props = {};
export default class App extends Component<Props> {
  constructor(props) {
    super(props)
    this.state = {
      ammount: 0
    }
  }
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.instructions}>address: 0xb6f94aE77977d7B0A083CF3a9fd01B2c174Feb60</Text>
        <Text style={styles.instructions}>amount: {this.state.ammount}</Text>
        <Button
          onPress={() => {
            NativeModules.web3go.getBalance("0xb6f94aE77977d7B0A083CF3a9fd01B2c174Feb60", value => {
              console.log("返回的 " + value)
              alert(value)
              this.setState({
                ammount: value
              })
            })
          }}
          title="getBalance"
          color="#841584"
        />
        <Button
          onPress={() => {
            NativeModules.web3go.getBlockByNumber(303, value => {
              let arr = value.split("&&")
              let wallet = {}
              wallet['blockNumber'] = arr[0]
              wallet['blockGasLimit'] = arr[1]
              wallet['blockGasUsed'] = arr[2]
              wallet['blockInt64'] = arr[3]
              wallet['blockTime'] = arr[4]
              wallet['blockMixDigestHex'] = arr[5]
              wallet['blockNonce'] = arr[6]
              wallet['blockCoinbaseHex'] = arr[7]
              wallet['blockRootHex'] = arr[8]
              wallet['blockHashHex'] = arr[9]
              wallet['blockTransactionsSize'] = arr[10]
              console.log(wallet)
            })
          }}
          title="getBlockByNumber"
          color="#841584"
        />
        <Button
          onPress={() => {
            NativeModules.web3go.getTransactionsWithHash("0xb37ae04a5ba320ab9a7fc5b3cf457a8bc07a9c79d0797000cb1993803da8910e", value => {
              let arr = value.split("&&")
              let wallet = {}
              wallet['hash'] = arr[0]
              wallet['value'] = arr[1]
              wallet['gas'] = arr[2]
              wallet['gasPrise'] = arr[3]
              wallet['nonce'] = arr[4]
              wallet['data'] = arr[5]
              wallet['to'] = arr[6]
              wallet['signHash'] = arr[7]
              console.log(wallet)
            })
          }}
          title="getTransactionsWithHash"
          color="#841584"
        />
        <Button
          onPress={() => {
            NativeModules.web3go.getTransactionReceipt("0xce14fea717381c5d3f25562ff35c2f6e2d95a52142adc717aefac3283ec37dfb", value => {
              console.log("返回的 " + value)
            })
          }}
          title="getTransactionReceipt"
          color="#841584"
        />
        <Button
          onPress={() => {
            NativeModules.web3go.sendTransaction("fdb711ae9b867af5b1fdc5dc51d4faeb96c8183d17129f87f8a188c7871cd800", "0xaf787c8316e3c43b13e5145f5c2b850e204b4a0f", value => {
              console.log("返回的 " + value)
            })
          }}
          title="sendTransaction"
          color="#841584"
        />
        <Button
          onPress={() => {
            NativeModules.web3go.generateWallet(value => {
              let arr = value.split("&&")
              let wallet = {}
              wallet['address'] = arr[0]
              wallet['priv_key'] = arr[1]
              wallet['pub_key'] = arr[2]
              console.log(wallet)
            })
          }}
          title="generate wallet"
          color="#841584"
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
