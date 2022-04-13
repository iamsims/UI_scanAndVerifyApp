import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
// import 'package:dart_ipfs_client/dart_ipfs_client.dart';
import 'package:ipfs_client_flutter/ipfs_client_flutter.dart';
// import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  late Client httpClient = Client();
  String myAddress = "";
  final String blockchainUrl = "https://rinkeby.infura.io/v3/11b5da3171f94a138ac566452555eba7";
  late Credentials _credentials;
  late Web3Client ethClient = Web3Client(blockchainUrl, httpClient);
  String privateKey = "";
  String publicKey = "";
  IpfsClient ipfsClient = IpfsClient(url:"https://ipfs.infura.io/ipfs/");

  ContractLinking(){
    initialSetup();
  }

  initialSetup() async{
    getContract();
  }

  Future<DeployedContract> getContract() async{
    String abiString = await rootBundle.loadString("ethereum/build/UserFactory.json");
    String contractAddress = "0x03138D8a09D9156A94E5BFbeD842E224FbEDA12c"; 
    String contractName = "UserFactory"; 
    
    var jsonAbi = jsonDecode(abiString);
    var _abiCode = jsonEncode(jsonAbi['abi']);
    print(_abiCode);
    DeployedContract contract = await DeployedContract(
      ContractAbi.fromJson(_abiCode, contractName),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

  Future<DeployedContract> getIdentityContract() async{
    String abiString = await rootBundle.loadString("ethereum/build/Identity.json");
    String contractAddress = myAddress; 
    String contractName = "Identity"; 
    
    var jsonAbi = jsonDecode(abiString);
    var _abiCode = jsonEncode(jsonAbi['abi']);
    print(_abiCode);
    DeployedContract contract = await DeployedContract(
      ContractAbi.fromJson(_abiCode, contractName),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

  Future<List<dynamic>> queryIdentity(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getIdentityContract();
    ContractFunction function = contract.function(functionName);
    List<dynamic> result = await ethClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    List<dynamic> result = await ethClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

  Future<String> transaction(String functionName, List<dynamic> args) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    dynamic result = await ethClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );

    return result;
  }

  Future<String> transactionIdentity(String functionName, List<dynamic> args) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await getIdentityContract();
    ContractFunction function = contract.function(functionName);
    dynamic result = await ethClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );

    return result;
  }

  Future<String> deploy(var data) async{
    var result = await transaction("createUser", []);
    print(result);
    myAddress= result;
    // var response = await ipfsClient.mkdir(dir:'myfolder');
    // print(response);
    String name= data!["Name"];
    var bytes = await data["Profile Photo"][0].readAsBytes();
    // var img = MemoryImage(bytes);
    var dat = {"name": name, "pic":bytes};
    var jsonString = jsonEncode(dat);
    print(jsonString);
    var res = await post(Uri.parse("https://ipfs.infura.io/ipfs/"),
      body:jsonString);
    print("the response was ");
    print(res.body);
    notifyListeners();
    return result.toString();
    
  }

  Future<EtherAmount> getBalance() async{
    // var cred = await ethClient.credentialsFromPrivateKey(privateKey);
    // print(cred);
    print("publicKey is "+ publicKey);
    EtherAmount balance = await ethClient.getBalance(EthereumAddress.fromHex(publicKey));
    print( balance.getValueInUnit(EtherUnit.ether));
    return balance;
  }

  void setPrivateKey(String privatekey, String publickey){
    // print('the private key to be stored is ' + privatekey);
    privateKey = privatekey;
    publicKey = publickey;
    notifyListeners();
  }

  String getPrivateKey(){
    return privateKey;
  }
}
