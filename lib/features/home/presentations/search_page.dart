import 'dart:async';

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

class SearchPage extends StatefulWidget {
  const SearchPage(this.searchKey, {Key? key}) : super(key: key);

  final String? searchKey;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchKey = '';
  late Timer _debounceTimer;
  late ProductSearchBloc productBloc;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    searchKey = widget.searchKey ?? '';

    productBloc = context.read<ProductSearchBloc>();
    _searchController.text = widget.searchKey ?? '';
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {});
    _pagingController.addPageRequestListener((pageKey) {
      productBloc.add(FetchItemEvent(pageKey, null, searchKey));
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
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: double.infinity,
            height: 45,
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Colors.grey.shade200), // Set the border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Colors.grey.shade400), // Set the border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Colors.grey.shade400), // Set the border color
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                suffixIcon: const Padding(
                  padding: EdgeInsets.all(8.0), // Adjust padding as needed
                  child: Icon(Icons.search),
                ),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  searchKey = value;
                });
                if (_debounceTimer.isActive) {
                  _debounceTimer.cancel();
                }
                _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                  productBloc.add(ResetSearchTermEvent(value, null));
                });
              },
            ),
          ),
        ),
      ),
      body: BlocConsumer<ProductSearchBloc, ProductListingState>(
        listener: (context, state) {
          if (state.status == LoadStatus.reset) {
            productBloc.add(FetchItemEvent(1, null, searchKey));
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
