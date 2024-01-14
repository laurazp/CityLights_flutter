import 'package:citylights/di/app_modules.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/model/resource_state.dart';
import 'package:citylights/presentation/view/monument/viewmodel/monuments_view_model.dart';
import 'package:citylights/presentation/widget/error/error_view.dart';
import 'package:citylights/presentation/widget/loading/loading_view.dart';
import 'package:citylights/presentation/widget/monument_list_row.dart';
import 'package:flutter/material.dart';

class MonumentsPage extends StatefulWidget {
  const MonumentsPage({super.key});

  @override
  State<MonumentsPage> createState() => _MonumentsPageState();
}

class _MonumentsPageState extends State<MonumentsPage> {
  final MonumentsViewModel _monumentsViewModel = inject<MonumentsViewModel>();
  List<Monument> _monuments = List.empty(growable: true);
  final ScrollController _scrollController = ScrollController();
  /*final PagingController<int, Monument> _pagingController =
      PagingController(firstPageKey: 0);*/

  bool _hasMoreItems = true;
  int _nextPage = 0;

  @override
  void initState() {
    super.initState();

    _monumentsViewModel.getMonumentListState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          setState(() {
            LoadingView.show(context);
          });
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          //setState(() {
          /*_pagingController.addPageRequestListener((pageKey) {
            _addMonuments(pageKey);
          });*/
          //_monuments = state.data!;
          _addMonuments(state.data!);
          //});
          break;
        case Status.ERROR:
          setState(() {
            LoadingView.hide();
            ErrorView.show(context, state.exception!.toString(), () {
              //TODO: aquí qué?
              _monumentsViewModel.fetchPagingMonumentList(_nextPage);
            });
          });
          break;
      }
    });

    /*_pagingController.addPageRequestListener((pageKey) {
      _addMonuments(pageKey);
    });*/

    //TODO: paginado
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMoreItems) {
        _monumentsViewModel.fetchPagingMonumentList(_nextPage);
      }
    });

    _monumentsViewModel.fetchPagingMonumentList(_nextPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monuments")),
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
    _monumentsViewModel.dispose();
    super.dispose();
  }

  Widget _getContentView() {
    return RefreshIndicator(
      onRefresh: () async {
        //TODO: gestionar paginado
        //_pagingController.refresh();
        _nextPage = 1;
        _monumentsViewModel.fetchPagingMonumentList(_nextPage);
      },
      child: Scrollbar(
        /*child: PagedListView(
          pagingController: _pagingController,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          builderDelegate: PagedChildBuilderDelegate<Monument>(
              itemBuilder: (context, item, index) {
            return MonumentListRow(monument: item);
          }),
        ),*/

        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _monuments.length,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemBuilder: (context, index) {
            final item = _monuments[index];
            return MonumentListRow(monument: item);
          },
        ),
      ),
    );
  }

  _addMonuments(List<Monument> response) async {
    if (_nextPage == 1) {
      _monuments.clear();
    }

    _monuments.addAll(response);
    _hasMoreItems = response.length > _monuments.length;
    _nextPage += 1;

    setState(() {});
  }

  /*_addMonuments(int offset) async {
    try {
      if (offset == 0) {
        _pagingController.itemList?.clear();
      }

      final monumentsResponse =
          await _monumentsViewModel.fetchPagingMonumentList(offset);

      //final end = _pagingController.itemList?.length == monumentsResponse.count;
      //final end = monumentsResponse.size < 100;

      /*if (end) {
        _pagingController.appendLastPage([]);
        return;
      }*/

      _pagingController.appendPage(
          monumentsResponse.results, monumentsResponse.count + offset);

      setState(() {});
    } catch (error) {
      _pagingController.error = error;
    }
  }*/
}
