import 'package:capture/features/home/models/product.dart';
import 'package:capture/features/transaction/cubit/create_transaction_cubit.dart';
import 'package:capture/features/transaction/model/snap_create.dart';
import 'package:capture/features/transaction/presentations/snap_page.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/main.dart';
import 'package:capture/services/app_router.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/dio_exceptions.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/widgets/loading_progress.dart';
import 'package:capture/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage(this.id, {Key? key}) : super(key: key);
  final int id;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: BlocConsumer<CreateTransactionCubit, DataState<SnapCreate>>(
        listener: (context, stateCreate) {
          logger.d(stateCreate.status);
          if (stateCreate.status == LoadStatus.success) {
            logger.d('Here');

            context.go(Destination.homePath);
            context.push(Destination.productDetailPath
                .replaceAll(':id', "${widget.id}"));
            logger.d(stateCreate.item?.token);
            context.push(
              Destination.paymentPath,
              extra: SnapPayment(
                token: stateCreate.item?.token,
                product: Product(),
              ).toRawJson(),
            );
          } else if (stateCreate.status == LoadStatus.failure) {
            logger.e(stateCreate.error?.message);
            DioExceptions e =
                DioExceptions.fromDioError(stateCreate.error!, context);
            showDialogMsg(context, e.message);
          }
        },
        builder: (context, stateCreate) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(24),
                child: MyButton(
                  onPressed: () {
                    showDialogInfo(
                      context,
                      () {
                        context
                            .read<CreateTransactionCubit>()
                            .createTransaction("${widget.id}");
                      },
                      title: 'Checkout',
                      message: 'Are you sure want to checkout?',
                    );
                  },
                  text: 'Checkout',
                ),
              ),
              if (stateCreate.status == LoadStatus.loading)
                const LoadingProgress(),
            ],
          );
        },
      ),
    );
  }
}
