import 'package:capture/features/history/bloc/history_bloc.dart';
import 'package:capture/features/history/model/history.dart';
import 'package:capture/features/home/bloc/list_pagination_event.dart';
import 'package:capture/features/transaction/presentations/payment_page.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/utils/data_list_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/utils/my_paged_list_view.dart';
import 'package:capture/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryBloc _historyBloc;
  final PagingController<int, History> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _historyBloc = context.read<HistoryBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _historyBloc.add(FetchItemEvent(pageKey));
    });
    _historyBloc.stream.listen((event) {
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
            _historyBloc.add(ResetPage());
          },
        ),
        child: BlocConsumer<HistoryBloc, DataListState<History>>(
          listener: (context, state) {
            if (state.status == LoadStatus.reset) {
              _historyBloc.add(FetchItemEvent(1));
            }
          },
          builder: (context, state) {
            if (state.status == LoadStatus.loading) {
              return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()));
            } else {
              return MyPagedListView<History>(
                pagingController: _pagingController,
                isSliver: false,
                itemBuilder: (context, item, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          // context.push(Destination.productDetailPath
                          //     .replaceAll(':id', "${item.idMerchant}"));
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: DataRowCustom(
                                DataValueCustom(
                                  leftValue: Text(formatDateTimeCustom(
                                      item.createdAt,
                                      format: 'dd-MMM-yyyy')),
                                  rightValue: TextBadge(
                                    text: Text(
                                      capitalize(
                                          item.statusPembayaran ?? 'Waiting'),
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
                            ListTile(
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
                              dense: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rp ${formatCurrency(item.totalHargaPackageMerchant)}',
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
                              trailing: SizedBox(
                                  width: 80,
                                  height: 35,
                                  child: MyButton(
                                    onPressed: () {},
                                    text: 'Cek',
                                    verticalPadding: 4,
                                    horizontalPadding: 4,
                                    fontSize: 14,
                                    borderRadius: 16,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            // return Text('data');
          },
        ),
      ),
    );
  }
}

class TextBadge extends StatelessWidget {
  final Text text;
  final Color color;
  final double horizontalPadding;
  final double verticalPadding;

  const TextBadge({
    super.key,
    required this.text,
    required this.color,
    this.horizontalPadding = 12,
    this.verticalPadding = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: text);
  }
}
