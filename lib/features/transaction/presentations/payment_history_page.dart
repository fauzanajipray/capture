import 'package:capture/constant/app.dart';
import 'package:capture/features/history/model/history.dart';
import 'package:capture/features/transaction/cubit/callback_payment_cubit.dart';
import 'package:capture/features/transaction/model/callback.dart';
import 'package:capture/features/transaction/model/transaction_callback.dart';
import 'package:capture/features/transaction/presentations/payment_page.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/main.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage(this.payment, {Key? key}) : super(key: key);

  final History? payment;

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  late final MidtransSDK? _midtrans;
  late CallbackPaymentCubit _callbackPaymentCubit;

  late Callback _request;

  @override
  void initState() {
    _callbackPaymentCubit = context.read<CallbackPaymentCubit>();
    _request = Callback();
    _request = _request.copyWith(
      totalHargaPackageMerchant: widget.payment?.totalHargaPackageMerchant,
      statusPembayaran: widget.payment?.statusPembayaran,
      noOrder: widget.payment?.noOrder,
    );
    _initSDK();
    super.initState();
  }

  void _initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: AppConstant.midtransKey,
        merchantBaseUrl: AppConstant.baseUrl,
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
      logger.d(result.toJson());
      TransactionCallback tc = TransactionCallback.fromJson(result.toJson());
      if (tc.transactionStatus == 'settlement' ||
          tc.transactionStatus == 'pending') {
        _showToast2(tc.statusMessage ?? 'Success Create Payment');
        _callbackPaymentCubit.callbackPayment(tc);
      }
    });
  }

  void _showToast2(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade500.withOpacity(0.2),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: BlocConsumer<CallbackPaymentCubit, DataState<Callback>>(
        listener: (context, state) {
          if (state.status == LoadStatus.success) {
            Callback? item = state.item;
            if (item != null) {
              setState(() {
                _request = item;
              });
            }
          }
        },
        builder: (context, state) {
          String? orderId = _request.noOrder;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 120,
                      child: Container(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Rp${formatCurrency(widget.payment?.totalHargaPackageMerchant)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Detail Transaksi',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    DataRowCustom(DataValueCustom(
                      leftValue: const Text(
                        'Merchant',
                        style: TextStyle(fontSize: 14),
                      ),
                      rightValue: Text(
                        widget.payment?.namaMerchant ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    )),
                    DataRowCustom(DataValueCustom(
                      leftValue: const Text(
                        'Qty',
                        style: TextStyle(fontSize: 14),
                      ),
                      rightValue: const Text(
                        '1',
                        style: TextStyle(fontSize: 14),
                      ),
                    )),
                    DataRowCustom(DataValueCustom(
                      leftValue: const Text(
                        'Price',
                        style: TextStyle(fontSize: 14),
                      ),
                      rightValue: Text(
                        formatCurrency(
                            widget.payment?.totalHargaPackageMerchant),
                        style: const TextStyle(fontSize: 14),
                      ),
                    )),
                    DataRowCustom(DataValueCustom(
                      leftValue: const Text(
                        'Status',
                        style: TextStyle(fontSize: 14),
                      ),
                      rightValue: Text(
                        capitalize(_request.statusPembayaran ?? 'waiting'),
                        style: const TextStyle(fontSize: 14),
                      ),
                    )),
                    if (orderId != null)
                      DataRowCustom(DataValueCustom(
                        leftValue: const Text(
                          'Order ID',
                          style: TextStyle(fontSize: 14),
                        ),
                        rightValue: Text(
                          capitalize(orderId ?? '-'),
                          style: const TextStyle(fontSize: 14),
                        ),
                      )),
                  ],
                ),
              ),
              if (_request.statusPembayaran == 'waiting')
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: MyButton(
                    onPressed: () async {
                      _midtrans?.startPaymentUiFlow(
                        token: widget.payment?.token ?? '',
                      );
                    },
                    color: const Color(0xFF304AAC),
                    horizontalPadding: 10,
                    verticalPadding: 20,
                    text: 'Bayar',
                    borderRadius: 10,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
