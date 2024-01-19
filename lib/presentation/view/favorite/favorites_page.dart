import 'package:citylights/di/app_modules.dart';
import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/presentation/model/resource_state.dart';
import 'package:citylights/presentation/view/favorite/favorites_provider.dart';
import 'package:citylights/presentation/view/favorite/viewmodel/favorites_view_model.dart';
import 'package:citylights/presentation/widget/error/error_view.dart';
import 'package:citylights/presentation/widget/favorite_list_row.dart';
import 'package:citylights/presentation/widget/loading/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesViewModel _favoritesViewModel = inject<FavoritesViewModel>();

  final List<FavoriteItem> _favorites = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _favoritesViewModel.getFavoriteListState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          setState(() {
            LoadingView.show(context);
          });
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          _addFavorites(state.data!);
          break;
        case Status.ERROR:
          setState(() {
            LoadingView.hide();
            ErrorView.show(context, state.exception!.toString(), () {
              _getFavorites();
            });
          });
          break;
      }
    });

    _getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: SafeArea(child: _getContentView()),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1050),
          curve: Curves.decelerate,
        ),
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  @override
  void dispose() {
    _favoritesViewModel.dispose();
    super.dispose();
  }

  Widget _getContentView() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Swipe to refresh your favorites"),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              _getFavorites();
            },
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _favorites.length,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemBuilder: (context, index) {
                  final item = _favorites[index];
                  return FavoriteListRow(favorite: item);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getFavorites() async {
    _favoritesViewModel.fetchFavoriteList();
    setState(() {});
  }

  _addFavorites(List<FavoriteItem> response) async {
    _favorites.clear();
    _favorites.addAll(response);
    Provider.of<FavoritesProvider>(context, listen: false).monuments =
        _favorites;
    setState(() {});
  }
}
