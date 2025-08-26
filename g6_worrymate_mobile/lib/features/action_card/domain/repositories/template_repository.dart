import 'package:dartz/dartz.dart';
import '../../../../../../lib/features/core/errors/failure.dart';
import '../../../../../../lib/features/core/params/params.dart';
import '../entities/template_entitiy.dart';

abstract class TemplateRepository {
  Future<Either<Failure, TemplateEntity>> getTemplate(
      {required TemplateParams params});
}
