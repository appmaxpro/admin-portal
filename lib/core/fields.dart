
import 'transforms.dart';
import 'base.dart';
import 'constants.dart';
import 'internal/field_builder.dart';

const Map<String, dynamic> _DEFAULT_PROPS = <String, dynamic>{};
const Meta _DEFAULT_META = const MetaField<dynamic,dynamic>(props: _DEFAULT_PROPS);

typedef SelectionFn = Future<List<Enum>> Function([Record record]);

class Enum {
  Enum(this.key, this.label);

  final String label;
  final dynamic key;
}

abstract class Field<T, V>{
  Field(this.name, {this.meta= _DEFAULT_META, this.target, this.transform});

  final String name;
  final MetaField meta;
  final String target;
  final Transform<T, V> transform;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(other, this);
  }

}

abstract class Relation {
  String get target;
  String get mappedBy;
  bool get orphan;
}

abstract class Fields<T, V> {

  factory Fields.text(String name) = FieldBuilder<T, V>.text;
  factory Fields.string(String name) = FieldBuilder<T, V>.string;
  factory Fields.bool(String name) = FieldBuilder<T, V>.bool;
  factory Fields.int(String name) = FieldBuilder<T, V>.int;
  factory Fields.double(String name, [int scale]) = FieldBuilder<T, V>.double;
  factory Fields.date(String name) = FieldBuilder<T, V>.date;
  factory Fields.dateTime(String name) = FieldBuilder<T, V>.dateTime;
  factory Fields.manyToOne(String name, String target) = FieldBuilder<T, V>.manyToOne;
  factory Fields.oneToMany(String name, String target, String mappedBy, [bool orphanRemoval])
    = FieldBuilder<T, V>.oneToMany;
  factory Fields.manyToMany(String name, String target, String mappedBy) = FieldBuilder<T, V>.manyToMany;
  factory Fields.binary(String name) = FieldBuilder<T, V>.binary;
  factory Fields.image(String name) = FieldBuilder<T, V>.image;
  factory Fields.currency(String name) = FieldBuilder<T, V>.string;
  factory Fields.selection(String name, List<Enum> selections) = FieldBuilder<T, V>.selection;
  factory Fields.selectionFn(String name, SelectionFn selectionFn) = FieldBuilder<T, V>.selectionFn;

  Fields<T, V> setMeta(MetaField value);
  Fields<T, V> setTransform(Transform<T, V> value);
  Fields<T, V> sortable([bool value=false]) ;
  Fields<T, V> searchable([bool value=false]);
  Fields<T, V> readonly([bool value=true]);
  Fields<T, V> required([bool value=true]);
  Fields<T, V> copy([bool value=false]);
  Fields<T, V> index([bool value=true]);
  Fields<T, V> unique([bool value=true]);

  Fields<T, V> addFlags(int flag);
  Fields<T, V> removeFlags(int flag);
  Fields<T, V> setFlag(int flag, bool value);
  Field<T, V> build();

  String get name;
  Transform<T, V> get transform;
  FieldType get type;
  String get target;
  String get mappedBy;
  bool get orphan;
  String get format;
  List<Enum> get selections;
  SelectionFn get selectionFn;
  MetaField get meta;
}