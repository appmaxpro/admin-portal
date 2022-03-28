
import 'base.dart';
import 'fields.dart';


class CachedRecord extends Record<Map<Field,dynamic>>{
  CachedRecord(this.data);
  @override
  final Map<Field,dynamic> data;

}