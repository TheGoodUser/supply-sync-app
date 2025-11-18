import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class EthService {
  final String rpcUrl = "http://192.168.73.150:8545";  // Hardhat RPC

  late Web3Client client;

  EthService() {
    client = Web3Client(rpcUrl, http.Client());
  }

  Future<String> sendEth({
    required String privateKey,
    required String toAddress,
    required BigInt amountInEther,
  }) async {
    final to = EthereumAddress.fromHex(toAddress);
    final credentials = EthPrivateKey.fromHex(privateKey);

    final txHash = await client.sendTransaction(
      credentials,
      Transaction(
        to: to,
        value: EtherAmount.fromUnitAndValue(
          EtherUnit.ether,
          amountInEther,
        ),
      ),
      chainId: 31337, // Hardhat default
    );

    return txHash;
  }
}
