
typedef Converter<V> = V Function(dynamic);
dynamic _any(dynamic d) => d;

const Converter<dynamic> DEFAULT_CONVERTER = _any;

bool _bool(dynamic d) {
  if (d is bool)
      return d;
  if (d is num)
     return d.toInt() != 0;
  if (d is String)
     return d == 'true' || d == 'on' || d == 't';
  return false;
}

String _string(dynamic d) {
  if (d is String)
    return d;

  return d != null ? d.toString() : null;
}

int _int(dynamic d) {
  if (d is int)
    return d;
  if (d is num)
    return d.toInt();

  if (d is String)
    return int.tryParse(d);


  return null;
}

double _double(dynamic d) {
  if (d is double)
    return d;

  if (d is num)
    return d.toDouble();

  if (d is String)
    return double.tryParse(d);

  return null;
}

const Converter<bool> BOOL_CONVERTER = _bool;
const Converter<int> INT_CONVERTER = _int;
const Converter<double> DOUBLE_CONVERTER = _double;
const Converter<String> STRING_CONVERTER = _string;

abstract class Transform<In, Out>{
  const Transform();

  Out toOut(In data);
  In toIn(Out data);
}

class GenericTransform<In, Out> extends Transform<In, Out>{

  const GenericTransform(
      this.inp,
      this.out);

  final Converter<In> inp;
  final Converter<Out> out;

  @override
  Out toOut(In data) => out(data);

  @override
  In toIn(Out data) => inp(data);

}

class _StringTransform extends Transform<String, String> {
  const _StringTransform();
  @override
  String toIn(String data) => data;
  @override
  String toOut(String data) => data;
}

const STRING_BOOL_TRANSFORM = GenericTransform(STRING_CONVERTER, BOOL_CONVERTER);
const ANY_BOOL_TRANSFORM = GenericTransform<dynamic, bool>(DEFAULT_CONVERTER, BOOL_CONVERTER);
const ANY_DOUBLE_TRANSFORM = GenericTransform<dynamic, double>(DEFAULT_CONVERTER, DOUBLE_CONVERTER);
const ANY_INT_TRANSFORM = GenericTransform<dynamic, int>(DEFAULT_CONVERTER, INT_CONVERTER);
const STRING_TRANSFORM = const _StringTransform();
