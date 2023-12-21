import 'package:citylights/data/monument/monuments_data_impl.dart';
import 'package:citylights/data/monument/remote/monuments_remote_impl.dart';
import 'package:citylights/data/remote/network_client.dart';
import 'package:citylights/domain/monuments_repository.dart';
import 'package:citylights/presentation/view/monument/viewmodel/monuments_view_model.dart';
import 'package:get_it/get_it.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupMonumentModule();
  }

  _setupMainModule() {
    inject.registerSingleton(NetworkClient());
  }

  _setupMonumentModule() {
    inject.registerFactory(
        () => MonumentsRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<MonumentsRepository>(
        () => MonumentsDataImpl(remoteImpl: inject.get()));
    inject.registerFactory(
        () => MonumentsViewModel(monumentsRepository: inject.get()));
  }
}
