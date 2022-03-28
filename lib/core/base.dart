import 'package:flutter/foundation.dart';
import 'transforms.dart';
import 'constants.dart';



class Meta{
  const Meta({this.flags, this.props});
  final int flags;
  final Map<String, dynamic> props;

  V get<V>(String prop, [V def]) => props[prop]??def;
}

class MetaField<T, V> extends Meta{
  const MetaField({this.type=FieldType.STRING, this.format, this.transform,
    int flags,Map<String, dynamic> props}):
      super(flags:flags, props:props);

  final FieldType type;
  final String format;
  final Transform<T, V> transform;

  bool get primary => (flags & FLAG_PRIMARY) != 0;
  bool get index => (flags & FLAG_INDEX) != 0;
  bool get readonly => (flags & FLAG_READONLY) != 0;
  bool get required => (flags & FLAG_REQUIRED) != 0;
  bool get unique => (flags & FLAG_UNIQUE) != 0;
  bool get sequence => (flags & FLAG_SEQUENCE) != 0;
  bool get searchable => (flags & FLAG_SEARCHABLE) != 0;
  bool get sortable => (flags & FLAG_SORTABLE) != 0;
  bool get copy => (flags & FLAG_COPYABLE) != 0;
  bool get isReference => type == FieldType.M2O;
  bool get isCollection => type == FieldType.O2M || type == FieldType.M2M;
  bool get virtual => (flags & FLAG_VIRTUAL) != 0;
  bool get isEnum => type == FieldType.ENUM;
  bool get massUpdate => (flags & FLAG_MASS_UPDATE) != 0;
  bool get isVersion => (flags & FLAG_VERSION) != 0;
  bool get transient => (flags & FLAG_TRANSIENT) != 0;


}

class MetaModel extends Meta{
  const MetaModel(this.name, {@required int flags, @required Map<String, dynamic> props}):
        super(flags:flags, props:props);

  final String name;
}

abstract class Record<D>{
  D get data;
}
//bool _is(int flags, )






