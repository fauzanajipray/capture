import 'package:capture/constant/app.dart';
import 'package:capture/widgets/my_button.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // final midpay = Midpay();

  // int id = 1;

  // //test payment
  // _testPayment() {
  //   //for android auto sandbox when debug and production when release
  //   midpay.init(AppConstant.midtransKey, AppConstant.baseUrl,
  //       environment: Environment.sandbox);
  //   midpay.setFinishCallback(_callback);
  //   var midtransCustomer = MidtransCustomer(
  //       'Zaki', 'Mubarok', 'kakzaki@gmail.com', '085704703691');
  //   List<MidtransItem> listitems = [];
  //   var midtransItems = MidtransItem('$id', 50000, 2, 'Charger');
  //   listitems.add(midtransItems);
  //   var midtransTransaction = MidtransTransaction(
  //       100000, midtransCustomer, listitems,
  //       skipCustomer: true);
  //   midpay
  //       .makePayment(midtransTransaction)
  //       .catchError((err) => print("ERROR $err"));
  //   setState(() {
  //     id++;
  //   });
  // }

  // //calback
  // Future<void> _callback(TransactionFinished finished) async {
  //   print("Finish $finished");
  //   return Future.value(null);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: MyButton(
          onPressed: () {},
          text: 'Proses',
        ),
      ),
    );
  }
}
