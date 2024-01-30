import 'package:capture/constant/app.dart';
import 'package:capture/features/home/bloc/recomendation_bloc.dart';
import 'package:capture/features/home/bloc/recomendation_event.dart';
import 'package:capture/features/home/cubit/category_cubit.dart';
import 'package:capture/features/home/models/category.dart';
import 'package:capture/features/home/models/product.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/main.dart';
import 'package:capture/services/app_router.dart';
import 'package:capture/utils/data_list_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/utils/my_paged_list_view.dart';
import 'package:capture/widgets/error_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late final CategoryCubit _categoryCubit;
  late final RecomendationBloc _blocRecomendation;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);

  String searchText = '';

  @override
  void initState() {
    _categoryCubit = context.read<CategoryCubit>();
    _blocRecomendation = context.read<RecomendationBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _blocRecomendation.add(FetchItemEvent(pageKey));
    });
    _blocRecomendation.stream.listen((event) {
      if (event.status == LoadStatus.success) {
        _pagingController.value = PagingState(
          nextPageKey: event.nextPageKey,
          itemList: event.itemList,
          error: null,
        );
      } else if (event.status == LoadStatus.failure) {
        _pagingController.error = event.error;
      }
    });
    initAsyncData();
    super.initState();
  }

  void initAsyncData() async {
    await _categoryCubit.getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () {
            initAsyncData();
            _blocRecomendation.add(ResetPage());
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Capture'),
              pinned: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      onEditingComplete: () {
                        context.push(Destination.searchPath
                            .replaceAll(':key', searchText));
                        setState(() {
                          searchText = '';
                          _searchController.text = '';
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: const Text(
                  'Kategori',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 16, top: 16),
                height: 70,
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state.status == LoadStatus.success) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          Category item = state.data[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () {
                                context.push(
                                  Destination.categoryProductPath.replaceAll(
                                      ':id', item.idKategori ?? '0'),
                                  extra: item.namaKategori,
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70.0),
                                child: Image.network(
                                  '${AppConstant.baseUrlImage}/logo/${item.logo}',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state.status == LoadStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == LoadStatus.failure) {
                      // return const Text('Error');
                      return Center(
                          child: errorData(context, state.error,
                              isImage: false,
                              onRetry: () => _categoryCubit.getCategory()));
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: const Text(
                  'Rekomendasi',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ),
            BlocConsumer<RecomendationBloc, DataListState<Product>>(
              listener: (context, state) {
                if (state.status == LoadStatus.reset) {
                  _blocRecomendation.add(FetchItemEvent(1));
                }
              },
              builder: (context, state) {
                logger.d(state.status);
                if (state.status == LoadStatus.loading) {
                  return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return MyPagedListView<Product>(
                    pagingController: _pagingController,
                    isSliver: true,
                    itemBuilder: (context, item, index) {
                      return ProductCard(item, null);
                    },
                  );
                }
                // return Text('data');
              },
            )
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard(this.item, this.margin, {super.key});
  final Product item;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: (margin != null)
          ? margin
          : const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: InkWell(
          onTap: () {
            context.push(Destination.productDetailPath
                .replaceAll(':id', "${item.idMerchant}"));
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: Colors.transparent, //
                  width: 145.0,
                  height: 90.0,
                  child: Image.network(
                    '${AppConstant.baseUrlImage}/logo/${item.logo}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Error'));
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    '${item.namaMerchant}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w600,
                      height: 0.08,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rp ${formatCurrency(item.totalHargaPackageMerchant ?? 0)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          height: 0.13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final String imageUrl;

  const RoundedImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66E5E5E5),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(70),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
