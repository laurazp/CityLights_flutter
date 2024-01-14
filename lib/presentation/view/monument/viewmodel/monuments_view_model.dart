import 'dart:async';

import 'package:citylights/domain/monuments_repository.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/base/base_view_model.dart';
import 'package:citylights/presentation/model/resource_state.dart';

class MonumentsViewModel extends BaseViewModel {
  final MonumentsRepository _monumentsRepository;

  final StreamController<ResourceState<List<Monument>>> getMonumentListState =
      StreamController();
  final StreamController<ResourceState<Monument>> getMonumentDetailState =
      StreamController();
  final StreamController<ResourceState<List<Monument>>>
      getMapMonumentListState = StreamController();

  MonumentsViewModel({required MonumentsRepository monumentsRepository})
      : _monumentsRepository = monumentsRepository;

  fetchMapMonumentList() {
    getMapMonumentListState.add(ResourceState.loading());

    _monumentsRepository
        .getMonumentList()
        .then((value) =>
            getMapMonumentListState.add(ResourceState.success(value)))
        .catchError(
            (error) => getMapMonumentListState.add(ResourceState.error(error)));
  }

  //TODO: Modificar para que acepte paginado
  fetchPagingMonumentList() {
    getMonumentListState.add(ResourceState.loading());

    _monumentsRepository
        .getMonumentList()
        .then((value) => getMonumentListState.add(ResourceState.success(value)))
        .catchError(
            (error) => getMonumentListState.add(ResourceState.error(error)));
  }

  fetchMonumentDetail(String monumentId) {
    getMonumentDetailState.add(ResourceState.loading());

    _monumentsRepository
        .getMonumentDetail(monumentId)
        .then(
            (value) => getMonumentDetailState.add(ResourceState.success(value)))
        .catchError(
            (error) => getMonumentDetailState.add(ResourceState.error(error)));
  }

  addMonumentToFavorites(String? monumentId) {
    //TODO: implementar y gestionar nulo??
  }

  @override
  void dispose() {
    getMonumentListState.close();
  }
}
