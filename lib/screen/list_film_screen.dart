import 'package:film_newwave/main.dart';
import 'package:film_newwave/model/film.dart';
import 'package:film_newwave/model/response_list.dart';
import 'package:film_newwave/system/network/client.dart';
import 'package:film_newwave/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Size? appSize;

class ListFilmScreen extends StatefulWidget {
  const ListFilmScreen({Key? key}) : super(key: key);

  @override
  _ListFilmScreenState createState() => _ListFilmScreenState();
}

class _ListFilmScreenState extends State<ListFilmScreen> {
  RefreshController? _refreshController;
  List<Film> films = [];
  int pageIndex = 1;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  Future<void> _getFilms() async {
    Map<String, dynamic> params = {
      'api_key': '26763d7bf2e94098192e629eb975dab0',
      'page': pageIndex.toString()
    };
    Map<String, dynamic>? response = await Client.get(path: '/3/discover/movie', params: params);
    if (response == null) return;
    ResponseList responseList = ResponseList.fromJson(response);
    if (isRefreshing) films.clear();
    responseList.results?.forEach((element) {
      films.add(element);
    });
    _refreshController?.loadComplete();
    if (responseList.totalPages == pageIndex) _refreshController?.loadNoData();
    setState(() {});
  }

  void _onRefresh() async {
    pageIndex = 1;
    isRefreshing = true;
    await _getFilms();
    isRefreshing = false;
    _refreshController?.refreshCompleted();
  }

  void _onLoading() async {
    pageIndex++;
    await _getFilms();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appSize = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Popular list',
                style: theme.textTheme.headline4,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController ?? RefreshController(),
                enablePullUp: true,
                enablePullDown: true,
                onLoading: _onLoading,
                onRefresh: _onRefresh,
                child: MasonryGridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemCount: films.length,
                    itemBuilder: (context, index) => ItemFilm(index, films[index])),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            Text(
              'Back',
              style: theme.textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }
}

class ItemFilm extends StatelessWidget {
  final int? index;
  final Film? film;

  const ItemFilm(this.index, this.film, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appSize!.width * 0.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.primaryColor,
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 6),
                blurRadius: 6,
                blurStyle: BlurStyle.normal)
          ]),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              film?.posterPath ?? '',
              fit: BoxFit.fill,
              width: (appSize!.width / 2),
              height: appSize!.width * 0.6,
              errorBuilder: (context, error, stack) => Center(child: Text('No Image')),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    film?.releaseDate ?? '',
                    style: theme.textTheme.bodyText1?.apply(color: Colors.white),
                  ),
                  SizedBox(
                    width: appSize!.width / 2 - 40,
                    child: Text(
                      (film?.title ?? '').toUpperCase(),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headline5?.apply(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 12,
              right: 12,
              child: ItemPoint(
                point: film?.voteAverage?.toString(),
              )),
        ],
      ),
    );
  }
}

class ItemPoint extends StatelessWidget {
  final String? point;
  const ItemPoint({this.point = '.', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: point!.split('.')[0].isNotEmpty,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration:
            BoxDecoration(gradient: AppColor.point, borderRadius: BorderRadius.circular(100)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(point?.split('.')[0] ?? '',
                style: theme.textTheme.headline5?.copyWith(fontSize: 17, color: Colors.white),
                textScaleFactor: 1.5),
            Text('.',
                style: theme.textTheme.bodyText1?.copyWith(fontSize: 17, color: Colors.white)),
            Text(point?.split('.')[0] ?? '',
                style: theme.textTheme.bodyText1?.copyWith(fontSize: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
