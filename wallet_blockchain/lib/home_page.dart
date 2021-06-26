import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

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

  final address = '0xEc0B19814E98c93eD6F0859fEdE4f92F40bD1431';
  int amount = 0;
  bool data = false;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client('', httpClient);
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
                    ? "\$1".text.bold.xl6.makeCentered()
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
                onPressed: () {},
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
                onPressed: () {},
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
                onPressed: () {},
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
}
