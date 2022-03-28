
import '../fields.dart';

abstract class BaseField<T, V> extends Field<T, V>{
  BaseField(Fields<T, V> builder):
        super(builder.name, transform:builder.transform,
          meta:builder.meta, target: builder.target);


}

class Bool<In> extends BaseField<In, bool>{
  Bool(Fields<In, bool> builder): super(builder);
}

class Text<In> extends BaseField<In, String>{
  Text(Fields<In, String> builder): super(builder);
}

class Integer<In> extends BaseField<In, int>{
  Integer(Fields<In, int> builder): super(builder);
}

class Double<In> extends BaseField<In, double>{
  Double(Fields<In, double> builder): super(builder);
}

class _Relation<In, Out> extends BaseField<In, Out> implements Relation{
  _Relation(Fields<In, Out> builder):
        mappedBy = builder.mappedBy,
        orphan = builder.orphan,
        super(builder);
  final String mappedBy;
  final bool orphan;
}

class M2o<In, Out> extends _Relation<In, Out>{
  M2o(Fields<In, Out> builder): super(builder);
}

class _X2m<In, Out> extends _Relation<In, Out>{
  _X2m(Fields<In, Out> builder): super(builder);
}

class O2m<In, Out> extends _X2m<In, Out>{
  O2m(Fields<In, Out> builder):
        orphan = builder.orphan,
        super(builder);

  final bool orphan;
}

class M2m<In, Out> extends _X2m<In, Out>{
  M2m(Fields<In, Out> builder): super(builder);


}

class Selection<Out> extends BaseField<dynamic, Enum>{
  Selection(Fields<dynamic, Enum> builder):
        selections = builder.selections,
        super(builder);
  final List<Enum> selections;
}

class Selection2<Out> extends BaseField<dynamic, Enum>{
  Selection2(Fields<dynamic, Enum> builder):
        fn = builder.selectionFn,
        super(builder);
  final SelectionFn fn;
}

class Binary extends BaseField<dynamic, dynamic>{
  Binary(Fields<dynamic, dynamic> builder):
        super(builder);
}