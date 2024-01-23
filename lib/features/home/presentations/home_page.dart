import 'package:capture/features/home/cubit/category_cubit.dart';
import 'package:capture/features/home/models/category.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/widgets/error_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();

  late final CategoryCubit _categoryCubit;

  @override
  void initState() {
    _categoryCubit = context.read<CategoryCubit>();
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
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(left: 8, top: 16),
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
                margin: const EdgeInsets.only(left: 8, top: 16),
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
                                print('Gambar diklik!');
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70.0),
                                child: Image.network(
                                  "https://via.placeholder.com/70x70",
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
                padding: const EdgeInsets.only(left: 8, top: 16),
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
            )
          ],
        ),
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final String imageUrl;

  const RoundedImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70),
        boxShadow: [
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
