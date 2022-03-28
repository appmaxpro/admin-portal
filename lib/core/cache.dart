
import 'records.dart';
import 'base.dart';
import 'fields.dart';

abstract class DataCache{

  Map<MetaModel, RecordCache> _caches;

  dynamic get(MetaModel model, dynamic id, Field field){
    return _caches[model].get(id, field);
  }

  void set(MetaModel model, dynamic id, Field field, dynamic value){
    _caches[model].set(id, field, value);
  }

  RecordCache getCache(MetaModel model) {
    return _caches[model];
  }

}

class RecordCache{
  final Map<dynamic, Map<Field, dynamic>> _cache =
                          <dynamic,Map<Field, dynamic>>{};

  Record getRecord(dynamic id) {
    return CachedRecord(_cache[id]??<Field, dynamic>{});
  }

  dynamic get(dynamic id, Field field) {
    return _cache[id][field];
  }

  void set(dynamic id, Field field, dynamic value){
    _cache[id][field] = value;
  }

  int get length => _cache.length;

  void clear() {_cache.clear();}

}