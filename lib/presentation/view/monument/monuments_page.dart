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
  List<Monument> _filteredMonuments = List.empty(growable: true);

  final TextEditingController _searchController = TextEditingController();
  bool _isAscendingOrder = false;

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
          _filterMonuments();
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
      appBar: AppBar(
        title: const Text("Monuments"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchBar();
            },
          ),
          IconButton(
            icon: Icon(_isAscendingOrder
                ? Icons.sort_by_alpha
                : Icons.sort_by_alpha_outlined),
            onPressed: () {
              _toggleSortOrder();
            },
          ),
        ],
      ),
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
          itemCount: _filteredMonuments.length,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemBuilder: (context, index) {
            final item = _filteredMonuments[index];
            return MonumentListRow(monument: item);
          },
        ),
      ),
    );
  }

  _filterMonuments() {
    String searchTerm = _searchController.text.toLowerCase();

    if (searchTerm.isEmpty) {
      _filteredMonuments = _monuments;
    } else {
      _filteredMonuments = _monuments
          .where(
              (monument) => monument.title.toLowerCase().contains(searchTerm))
          .toList();
    }

    setState(() {});
  }

  _showSearchBar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Search Monuments"),
          content: TextField(
            controller: _searchController,
            onChanged: (value) {
              _filterMonuments();
            },
            decoration: const InputDecoration(
              hintText: "Enter Monument Title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //TODO: limpiar string? _searchController.text = "";
                Navigator.of(context).pop();
              },
              child: const Text("Accept"),
            ),
          ],
        );
      },
    );
  }

  _sortMonuments() {
    _filteredMonuments.sort((a, b) {
      return _isAscendingOrder
          ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
          : b.title.toLowerCase().compareTo(a.title.toLowerCase());
    });
  }

  _toggleSortOrder() {
    _isAscendingOrder = !_isAscendingOrder;
    _sortMonuments();
    setState(() {});
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
