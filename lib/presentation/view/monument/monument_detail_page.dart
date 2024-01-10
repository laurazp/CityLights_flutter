import 'package:cached_network_image/cached_network_image.dart';
import 'package:citylights/di/app_modules.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/model/resource_state.dart';
import 'package:citylights/presentation/view/monument/viewmodel/monuments_view_model.dart';
import 'package:citylights/presentation/widget/error/error_view.dart';
import 'package:citylights/presentation/widget/loading/loading_view.dart';
import 'package:flutter/material.dart';

class MonumentDetailPage extends StatefulWidget {
  const MonumentDetailPage({super.key, required this.monumentId});

  final String monumentId;

  @override
  State<MonumentDetailPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MonumentDetailPage> {
  final MonumentsViewModel _viewModel = inject<MonumentsViewModel>();
  Monument? _monument;

  @override
  void initState() {
    super.initState();

    _viewModel.getMonumentDetailState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          setState(() {
            LoadingView.show(context);
          });
          break;
        case Status.SUCCESS:
          setState(() {
            LoadingView.hide();
            _monument = state.data;
          });
          break;
        case Status.ERROR:
          debugPrint("Error: ${state.exception.toString()}");
          setState(() {
            LoadingView.hide();
            ErrorView.show(context, state.exception.toString(), () {
              _viewModel.fetchMonumentDetail(widget.monumentId);
            });
          });
          break;
      }
    });

    _viewModel.fetchMonumentDetail(widget.monumentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_monument?.title ?? ''),
        ),
        body: _getContentView());
  }

  Widget _getContentView() {
    if (_monument == null) return Container();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: _monument!.image,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text("Description: ${_monument!.description}"),
            const SizedBox(height: 16),
            Text("Style: ${_monument!.style}"),
            const SizedBox(height: 16),
            Text("Opening hours: ${_monument!.hours}"),
            const SizedBox(height: 16),
            Text("Address: ${_monument!.address}"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
