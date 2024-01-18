import 'package:citylights/data/favorite/favorites_data_impl.dart';
import 'package:citylights/data/favorite/remote/favorites_remote_impl.dart';
import 'package:citylights/data/monument/monuments_data_impl.dart';
import 'package:citylights/data/monument/remote/monuments_remote_impl.dart';
import 'package:citylights/data/remote/network_client.dart';
import 'package:citylights/domain/favorites_repository.dart';
import 'package:citylights/domain/monuments_repository.dart';
import 'package:citylights/presentation/view/favorite/viewmodel/favorites_view_model.dart';
import 'package:citylights/presentation/view/monument/viewmodel/monuments_view_model.dart';
import 'package:get_it/get_it.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupMonumentModule();
    _setupFavoriteModule();
  }

  _setupMainModule() {
    inject.registerSingleton(NetworkClient());
  }

  _setupMonumentModule() {
    inject.registerFactory(
        () => MonumentsRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<MonumentsRepository>(() => MonumentsDataImpl(
        remoteImpl: inject.get(), remoteFirebaseImpl: inject.get()));
    inject.registerFactory(
        () => MonumentsViewModel(monumentsRepository: inject.get()));
  }

  _setupFavoriteModule() {
    inject.registerFactory(() => FavoritesRemoteImpl());
    inject.registerFactory<FavoritesRepository>(
        () => FavoritesDataImpl(remoteImpl: inject.get()));
    inject.registerFactory(
        () => FavoritesViewModel(favoritesRepository: inject.get()));
  }
}
