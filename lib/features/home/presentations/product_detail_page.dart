import 'package:capture/constant/app.dart';
import 'package:capture/features/home/cubit/product_detail_cubit.dart';
import 'package:capture/features/home/models/product_detail.dart';
import 'package:capture/features/transaction/cubit/create_transaction_cubit.dart';
import 'package:capture/features/transaction/model/snap_create.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/main.dart';
import 'package:capture/services/app_router.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/dio_exceptions.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/widgets/error_data.dart';
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
  late ProductDetailCubit _productCubit;
  late ProductDetail _request;

  @override
  void initState() {
    _request = ProductDetail();
    _productCubit = context.read<ProductDetailCubit>();
    initAsyncData();
    super.initState();
  }

  void initAsyncData() async {
    await _productCubit.getProductDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: BlocConsumer<ProductDetailCubit, DataState<ProductDetail>>(
        listener: (context, state) {
          if (state.status == LoadStatus.success) {
            ProductDetail? item = state.item;
            if (item != null) {
              setState(() {
                _request = item;
              });
            }
          }
        },
        builder: (context, state) {
          if (state.status == LoadStatus.initial ||
              state.status == LoadStatus.loading) {
            if (state.item == null) {
              return const LoadingProgress();
            } else {
              return Container();
            }
          } else if (state.status == LoadStatus.failure) {
            return Center(
                child: errorData(context, state.error,
                    onRetry: () => _productCubit.getProductDetail(widget.id)));
          }
          return BlocConsumer<CreateTransactionCubit, DataState<SnapCreate>>(
            listener: (context, stateCreate) {
              if (stateCreate.status == LoadStatus.success) {
                logger.d('Here');

                context.go(Destination.homePath);
                context.push(Destination.productDetailPath
                    .replaceAll(':id', "${widget.id}"));
                logger.d(stateCreate.item?.token);
                context.push(Destination.paymentPath,
                    extra: SnapPayment(
                      token: stateCreate.item?.token,
                      product: _request,
                    ).toRawJson());
              } else if (stateCreate.status == LoadStatus.failure) {
                DioExceptions e =
                    DioExceptions.fromDioError(stateCreate.error!, context);
                showDialogMsg(context, e.message);
              }
            },
            builder: (context, stateCreate) {
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 309,
                                      decoration: ShapeDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        shadows: const [
                                          BoxShadow(
                                            color: Color(0x66E5E5E5),
                                            blurRadius: 7.33,
                                            offset: Offset(0, 7.33),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Expanded(
                                              child: SizedBox.shrink()),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            height: 65,
                                            child: Text(
                                              _request.namaMerchant ?? '',
                                              style: TextStyle(
                                                color: Colors.black.withOpacity(
                                                    0.8500000238418579),
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 244,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              '${AppConstant.baseUrlImage}/logo/${_request.logo}'),
                                          fit: BoxFit.fill,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 23),
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                      color: Colors.black
                                          .withOpacity(0.8500000238418579),
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w600,
                                      height: 0.07,
                                    ),
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 13),
                                  child: Text(
                                    _request.deskripsi ?? '',
                                    style: TextStyle(
                                      color: Colors.black
                                          .withOpacity(0.6000000238418579),
                                      fontSize: 15,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 40),
                                  child: Text(
                                    'Service',
                                    style: TextStyle(
                                      color: Colors.black
                                          .withOpacity(0.8500000238418579),
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w600,
                                      height: 0.07,
                                    ),
                                  ),
                                ),
                              ),
                              ..._buildProductPackage(_request),
                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 50)),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Harga",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            "Rp ${formatCurrency(_request.totalHargaPackageMerchant)}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 170,
                            height: 49,
                            child: MyButton(
                              verticalPadding: 10,
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
                        ),
                      ],
                    ),
                  ),
                  if (stateCreate.status == LoadStatus.loading)
                    const LoadingProgress(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildProductPackage(ProductDetail request) {
    int total = request.packagemerchant?.length ?? 0;

    return [
      SliverPadding(
        padding: const EdgeInsets.only(top: 10),
        sliver: SliverList(
          delegate:
              SliverChildBuilderDelegate(childCount: total, (context, index) {
            Packagemerchant? package = request.packagemerchant?[index];
            return Container(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.adjust,
                    color: Color.fromARGB(255, 4, 123, 221),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    '${package?.name}',
                    style: const TextStyle(fontSize: 15),
                  ))
                ],
              ),
            );
          }),
        ),
      )
    ];
  }
}
