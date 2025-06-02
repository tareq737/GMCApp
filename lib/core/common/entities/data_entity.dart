// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gmcappclean/core/common/entities/user_entity.dart';

class MetaDataEntity {
  DateTime createdAt;
  DateTime lastEditedAt;
  UserEntity createdBy;
  UserEntity lastEditedBy;
  MetaDataEntity({
    required this.createdAt,
    required this.lastEditedAt,
    required this.createdBy,
    required this.lastEditedBy,
  });
}
