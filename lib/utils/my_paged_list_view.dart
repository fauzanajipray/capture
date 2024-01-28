import 'package:capture/utils/empty_data.dart';
import 'package:capture/widgets/error_data.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MyPagedListView<T> extends StatelessWidget {
  const MyPagedListView({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
    this.isSliver = false,
    this.isMoreDataAvailable = false,
    this.notFound,
  });

  final PagingController<int, T> pagingController;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context)? notFound;
  final bool isMoreDataAvailable;
  final bool isSliver;

  @override
  Widget build(BuildContext context) {
    if (isSliver) {
      return PagedSliverList<int, T>(
        pagingController: pagingController,
        builderDelegate: _builderDelegate(),
      );
    }
    return PagedListView<int, T>(
      pagingController: pagingController,
      builderDelegate: _builderDelegate(),
    );
  }

  PagedChildBuilderDelegate<T> _builderDelegate() {
    return PagedChildBuilderDelegate<T>(
      animateTransitions: true,
      itemBuilder: (context, item, index) {
        return itemBuilder(context, item, index);
      },
      noItemsFoundIndicatorBuilder: notFound ?? emptyData,
      noMoreItemsIndicatorBuilder: (context) {
        return (isMoreDataAvailable)
            ? const Center(
                child: Text('No More Data'),
              )
            : const SizedBox(height: 24);
      },
      firstPageErrorIndicatorBuilder: (context) {
        return Center(
          child: errorData(
            context,
            pagingController.error,
            onRetry: () => pagingController.retryLastFailedRequest(),
          ),
        );
      },
    );
  }
}
