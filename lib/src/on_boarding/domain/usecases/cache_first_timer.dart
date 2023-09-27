import 'package:retro_bank_app/core/usecases/usecases.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/on_boarding/domain/repos/on_boarding_repo.dart';

class CacheFirstTimer extends UsecaseWithOutParams<void> {
  CacheFirstTimer(this._repo);

  final IOnBoardingRepo _repo;

  @override
  ResultVoid call() async => _repo.cacheFirstTimer();
}
