import 'package:capture/features/home/bloc/product_listing_bloc.dart';
import 'package:capture/features/home/bloc/product_listing_event.dart';
import 'package:capture/features/home/bloc/product_listing_state.dart';
import 'package:capture/features/home/models/product.dart';
import 'package:capture/features/home/presentations/home_page.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/utils/my_paged_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CategoryProductPage extends StatefulWidget {
  const CategoryProductPage(this.categoryId, this.categoryName, {Key? key})
      : super(key: key);

  final int categoryId;
  final String categoryName;

  @override
  State<CategoryProductPage> createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  late ProductSearchBloc productBloc;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    productBloc = context.read<ProductSearchBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      productBloc.add(FetchItemEvent(pageKey, widget.categoryId, null));
    });
    productBloc.stream.listen((event) {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(widget.categoryName),
      ),
      body: BlocConsumer<ProductSearchBloc, ProductListingState>(
        listener: (context, state) {
          if (state.status == LoadStatus.reset) {
            productBloc.add(FetchItemEvent(1, widget.categoryId, null));
          }
        },
        builder: (context, state) {
          return MyPagedListView<Product>(
            pagingController: _pagingController,
            itemBuilder: (context, item, index) {
              return ProductCard(
                  item, const EdgeInsets.symmetric(horizontal: 8));
            },
          );
        },
      ),
    );
  }
}
