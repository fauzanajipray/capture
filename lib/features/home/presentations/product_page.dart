import 'package:capture/constant/app.dart';
import 'package:capture/features/transaction/cubit/create_transaction_cubit.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/services/token_service.dart';
import 'package:capture/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
          text: 'Checkout',
        ),
      ),
    );
  }
}
