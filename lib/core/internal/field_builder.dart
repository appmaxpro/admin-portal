
import '../transforms.dart';
import '../fields.dart';
import '../base.dart';
import '../constants.dart';
import './_fields.dart';

class FieldBuilder<T, V> implements Fields<T, V>{
  FieldBuilder._(this.type, this.name);

  factory FieldBuilder.text(String name) => FieldBuilder<T, V>._(FieldType.TEXT, name);
  factory FieldBuilder.string(String name) => FieldBuilder<T, V>._(FieldType.STRING, name);
  factory FieldBuilder.bool(String name) => FieldBuilder<T, V>._(FieldType.BOOL, name);
  factory FieldBuilder.int(String name) => FieldBuilder<T, V>._(FieldType.INT, name);
  factory FieldBuilder.double(String name, [int scale]) =>
      FieldBuilder<T, V>._(FieldType.INT, name)..scale=scale;
  factory FieldBuilder.date(String name) => FieldBuilder<T, V>._(FieldType.INT, name);
  factory FieldBuilder.dateTime(String name) => FieldBuilder<T, V>._(FieldType.INT, name);
  factory FieldBuilder.binary(String name) => FieldBuilder<T, V>._(FieldType.BINARY, name);
  factory FieldBuilder.image(String name) =>
      FieldBuilder<T, V>._(FieldType.BINARY, name)..format='image';

  factory FieldBuilder.manyToOne(String name, String target) =>
      FieldBuilder<T, V>._(FieldType.M2O, name)..target = target;

  factory FieldBuilder.oneToMany(String name, String target,
      String mappedBy, [bool orphanRemoval]) =>
      FieldBuilder<T, V>._(FieldType.M2O, name)
        ..target = target
        ..mappedBy = mappedBy
        ..orphan = orphanRemoval;

  factory FieldBuilder.manyToMany(String name, String target,
      String mappedBy) =>
      FieldBuilder<T, V>._(FieldType.M2O, name)
        ..target = target
        ..mappedBy = mappedBy;

  factory FieldBuilder.selection(String name, List<Enum> selections) =>
      FieldBuilder<T, V>._(FieldType.ENUM, name)
        ..selections = selections;
  factory FieldBuilder.selectionFn(String name, SelectionFn selectionFn) =>
      FieldBuilder<T, V>._(FieldType.ENUM, name)
        ..selectionFn = selectionFn;

  factory FieldBuilder.currency(String name, String target, [int scale]) =>
      FieldBuilder<T, V>._(FieldType.INT, name)
        ..target = target
        ..scale = scale ;

  final String name;
  final FieldType type;
  MetaField meta;
  String target;
  String mappedBy;
  bool orphan;
  int scale;
  String format;
  Transform<T, V> transform;
  List<Enum> selections;
  SelectionFn selectionFn;
  int flags;

  @override
  Field<T, V> build() {
    switch(type){
      case FieldType.INT:
        transform = transform??ANY_INT_TRANSFORM;
        return Integer<T>(this as Fields<T, int>) as Field<T, V>;
      case FieldType.DOUBLE:
        transform = transform??ANY_DOUBLE_TRANSFORM;
        return Double<T>(this as Fields<T, double>) as Field<T, V>;
      case FieldType.BOOL:
        transform = transform??ANY_BOOL_TRANSFORM;
        return Bool<T>(this as Fields<T, bool>) as Field<T, V>;
      case FieldType.STRING:
      case FieldType.TEXT:
      default:
        transform = transform??STRING_TRANSFORM;
        return Text<T>(this as Fields<T, String>) as Field<T, V>;

    }

  }


  Fields<T, V> setMeta(MetaField value) {
    meta = value;
    return this;
  }
  Fields<T, V> setTransform(Transform<T, V> value) {
    transform = value;
    return this;
  }

  Fields<T, V> setFormat(String value) {
    format = value;
    return this;
  }

  Fields<T, V> sortable([bool value=false]) => setFlag(FLAG_SORTABLE, value);
  Fields<T, V> searchable([bool value=false]) => setFlag(FLAG_SEARCHABLE, value);
  Fields<T, V> readonly([bool value=true]) => setFlag(FLAG_READONLY, value);
  Fields<T, V> required([bool value=true]) => setFlag(FLAG_REQUIRED, value);
  Fields<T, V> copy([bool value=false]) => setFlag(FLAG_COPYABLE, value);
  Fields<T, V> index([bool value=true]) => setFlag(FLAG_INDEX, value);
  Fields<T, V> unique([bool value=true]) => setFlag(FLAG_UNIQUE, value);

  Fields<T, V> addFlags(int flag){
    flags |= flag;
    return this;
  }

  Fields<T, V> removeFlags(int flag){
    flags &= ~flag;
    return this;
  }

  Fields<T, V> setFlag(int flag, bool value){
    if (value) {
      flags |= flag;
    }
    else {
      flags &= ~flag;
    }
    return this;
  }



}