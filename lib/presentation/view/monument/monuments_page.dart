import 'package:citylights/di/app_modules.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/model/monument_list.dart';
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
  final List<Monument> _monuments = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();
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
          _addMonuments(state.data!);
          break;
        case Status.ERROR:
          setState(() {
            LoadingView.hide();
            ErrorView.show(context, state.exception!.toString(), () {
              _nextPage = 0;
              _monumentsViewModel.fetchPagingMonumentList(_nextPage);
            });
          });
          break;
      }
    });

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
        _nextPage = 0;
        _monumentsViewModel.fetchPagingMonumentList(_nextPage);
      },
      child: Scrollbar(
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

  _addMonuments(MonumentList response) async {
    if (_nextPage == 0) {
      _monuments.clear();
    }

    _monuments.addAll(response.result);
    _hasMoreItems = response.totalCount > _monuments.length;
    _nextPage += 1;

    setState(() {});
  }
}
