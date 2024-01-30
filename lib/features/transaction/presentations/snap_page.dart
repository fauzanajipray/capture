import 'package:capture/constant/app.dart';
import 'package:capture/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class SnapPage extends StatefulWidget {
  const SnapPage({Key? key}) : super(key: key);

  @override
  _SnapPageState createState() => _SnapPageState();
}

class _SnapPageState extends State<SnapPage> {
  late final MidtransSDK? _midtrans;

  @override
  void initState() {
    super.initState();
    _initSDK();
  }

  void _initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: AppConstant.midtransKey,
        merchantBaseUrl: "",
        colorTheme: ColorTheme(
          colorPrimary: const Color(0xFF304AAC),
          colorPrimaryDark: const Color(0xFF304AAC),
          colorSecondary: const Color(0xFF304AAC),
        ),
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) {
      _showToast('Transaction Completed', false);
    });
  }

  void _showToast(String msg, bool isError) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: isError ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF304AAC),
        appBarTheme: const AppBarTheme(
          backgroundColor: const Color(0xFF304AAC),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF304AAC)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payment Gateway Example App',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text("Pay Now"),
            onPressed: () async {
              final result = await TokenService().getToken();

              if (result.isRight()) {
                String? token = result.fold((l) => null, (r) => r.token);

                if (token == null) {
                  _showToast('Token cannot null', true);
                  return;
                }

                _midtrans?.startPaymentUiFlow(
                  token: token,
                );
              } else {
                _showToast('Transaction Failed', true);
              }
            },
          ),
        ),
      ),
    );
  }
}
