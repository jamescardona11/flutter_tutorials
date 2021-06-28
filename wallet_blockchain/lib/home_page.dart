import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'slider_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Client httpClient;
  late Web3Client ethClient;

  late String address;
  late String projecID;
  late String private;
  late String contract;

  int amount = 0;
  bool data = false;

  late var myData;

  @override
  void initState() {
    super.initState();
    address = dotenv.env['ADDRESS']!;
    projecID = dotenv.env['INFURA_CLIENT']!;
    private = dotenv.env['PRIVATE']!;
    contract = dotenv.env['CONTRACT']!;

    httpClient = Client();
    ethClient = Web3Client(
      'https://rinkeby.infura.io/v3/$projecID',
      httpClient,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox()
            .blue600
            .size(
              context.screenWidth,
              context.percentHeight * 30,
            )
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          '\$PKCoin'.text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(
            child: VStack(
              [
                'Balance'.text.gray700.xl2.semiBold.makeCentered(),
                10.heightBox,
                data
                    ? "\$$myData".text.bold.xl6.makeCentered()
                    : CircularProgressIndicator().centered()
              ],
            ),
          )
              .white
              .size(
                context.screenWidth,
                context.percentHeight * 18,
              )
              .rounded
              .shadowXl
              .make()
              .p16(),
          30.heightBox,
          SliderWidget(
            min: 0,
            max: 100,
            finalVal: (v) {
              amount = (v * 100).round();
            },
          ).centered(),
          30.heightBox,
          HStack(
            [
              TextButton.icon(
                onPressed: () => getBalance(address),
                icon: Icon(Icons.refresh, color: Colors.white),
                label: "Refresh".text.white.make(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => sendCoin(),
                icon: Icon(Icons.call_made_outlined, color: Colors.white),
                label: "Deposit".text.white.make(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => withdrawCoin(),
                icon: Icon(Icons.call_received_outlined, color: Colors.white),
                label: "Withdraw".text.white.make(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(),
                  ),
                ),
              ),
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          )
        ])
      ]),
    );
  }

  Future<void> getBalance(String targetAddress) async {
    // final address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query('getBalance', []);

    myData = result[0];
    data = true;

    setState(() {});
  }

  Future<String> sendCoin() async {
    final bigAmount = BigInt.from(amount);
    final response = await submit("depositBalance", [bigAmount]);

    print("Deposited");

    return response;
  }

  Future<String> withdrawCoin() async {
    final bigAmount = BigInt.from(amount);
    final response = await submit("withdrawBalance", [bigAmount]);

    print("withdraw");

    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(private);
    final contract = await loadContract();

    final ethFunction = contract.function(functionName);

    print('Cred: ${credentials.privateKey}');
    print('ethFunction: ${ethFunction.name}');
    print('contract: ${contract.address}');
    print('args: $args');

    final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
    );

    return result;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();

    final ethFunction = contract.function(functionName);

    final result = await ethClient(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');

    return DeployedContract(
        ContractAbi.fromJson(abi, 'PKCoin'), EthereumAddress.fromHex(contract));
  }
}
