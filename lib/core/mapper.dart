
import 'base.dart';
import 'fields.dart';
import 'models.dart';

class Mapper extends MetaModel{
  Mapper(String name, {int flags, Map<String, dynamic> props}):
        super(name, flags:flags, props:props){

  }

  static Map<String, Mapper> _mappers = <String, Mapper>{};

  final Map<String, Field> _fields = {};
  final List<String> names = [];

  static Mapper of(String name) => _mappers[name];

  Field getField(String name) => _fields[name];

  List<Field> get fields => _fields.values;


}