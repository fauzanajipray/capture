import 'package:capture/features/history/model/history.dart';
import 'package:capture/features/history/presentations/history_page.dart';
import 'package:capture/features/home/bloc/list_pagination_event.dart';
import 'package:capture/features/notification/bloc/notification_bloc.dart';
import 'package:capture/features/notification/model/notif.dart';
import 'package:capture/features/transaction/presentations/payment_page.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/utils/data_list_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/utils/my_paged_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final NotifBloc _notificationBloc;
  final PagingController<int, Notif> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _notificationBloc = context.read<NotifBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _notificationBloc.add(FetchItemEvent(pageKey));
    });
    _notificationBloc.stream.listen((event) {
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
        title: const Text('History'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () {
            _notificationBloc.add(ResetPage());
          },
        ),
        child: BlocConsumer<NotifBloc, DataListState<Notif>>(
          listener: (context, state) {
            if (state.status == LoadStatus.reset) {
              _notificationBloc.add(FetchItemEvent(1));
            }
          },
          builder: (context, state) {
            if (state.status == LoadStatus.loading) {
              return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()));
            } else {
              return Container(
                margin: const EdgeInsets.only(top: 16),
                child: MyPagedListView<Notif>(
                  pagingController: _pagingController,
                  isSliver: false,
                  itemBuilder: (context, item, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: DataRowCustom(
                                DataValueCustom(
                                  leftValue: Text(formatDateTimeCustom(
                                      item.createdAt,
                                      difference: true,
                                      format: 'dd-MMM-yyyy')),
                                  rightValue: TextBadge(
                                    text: Text(
                                      capitalize('Info'),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                              height: 120,
                              child: Container(
                                padding: EdgeInsets.only(top: 16),
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
                                  // dense: true,
                                  leading: const Icon(
                                    Icons.info,
                                    color: Colors.blue,
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      item.fillNotif ?? '-',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 4,
                                    ),
                                  ),
                                  minVerticalPadding: 8,
                                  horizontalTitleGap: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
