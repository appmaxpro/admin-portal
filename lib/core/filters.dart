/*
 * Axelor Business Solutions
 *
 * Copyright (C) 2005-2022 Axelor (<http://axelor.com>).
 *
 * This program is free software: you can redistribute it and/or  modify
 * it under the terms of the GNU Affero General Public License, version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'db/query.dart';
import '../utils/strings.dart';

import 'models.dart';
import 'operator.dart';

bool _notBlank(String st) => st != null && st.isNotEmpty;

abstract class Filter<T extends Model> {

  String _query;
  bool _translate;

  String getQuery();

  List<Object> getParams();

  Query<T> build(String klass) {
    Query<T> query = Query.of(klass);
    String queryFilter = toString();
    query.setTranslate(translate);

    int n = 0, i = queryFilter.indexOf('?');
    while (i > -1) {
      queryFilter = queryFilter.replaceRange(i, i + 1,  '?${++n}');
      i = queryFilter.indexOf('?', i + 1);
    }
    if (_notBlank(queryFilter)) {
      query.setFilter(queryFilter, getParams());
    }
    return query;
  }

  /**
   * Set whether to use translation join.
   *
   * @param translate
   * @return filter
   */
  Filter setTranslate([bool translate=true]) {
    this._translate = translate;
    return this;
  }

  bool get translate => _translate;
  void set translate(bool val) => _translate = val;

  @override
  String toString() {
    _query ??= getQuery();
    return _query;
  }

  
  static Filter equals(String fieldName, Object value) {
    return new SimpleFilter(Operator.EQ, fieldName, value);
  }

  static Filter notEquals(String fieldName, Object value) {
    return new SimpleFilter(Operator.NOT_EQ, fieldName, value);
  }

  static Filter lessThan(String fieldName, Object value) {
    return new SimpleFilter(Operator.LT, fieldName, value);
  }

  static Filter greaterThan(String fieldName, Object value) {
    return new SimpleFilter(Operator.GT, fieldName, value);
  }

  static Filter lessOrEqual(String fieldName, Object value) {
    return new SimpleFilter(Operator.LT_EQ, fieldName, value);
  }

  static Filter greaterOrEqual(String fieldName, Object value) {
    return new SimpleFilter(Operator.GT_EQ, fieldName, value);
  }

  static Filter like(String fieldName, Object value) {
    return _LikeFilter.like(fieldName, value);
  }

  static Filter notLike(String fieldName, Object value) {
    return _LikeFilter.notLike(fieldName, value);
  }

  static Filter isNull(String fieldName) {
    return _NullFilter.isNull(fieldName);
  }

  static Filter notNull(String fieldName) {
    return _NullFilter.isNotNull(fieldName);
  }

  static Filter inf(String fieldName, Iterable value) {
    return new _RangeFilter(Operator.IN, fieldName, value);
  }

  static Filter notIn(String fieldName, Iterable value) {
    return new _RangeFilter(Operator.NOT_IN, fieldName, value);
  }


  static Filter between(String fieldName, Object start, Object end) {
    return new _RangeFilter(Operator.BETWEEN, fieldName, [start, end]);
  }

  static Filter notBetween(String fieldName, Object start, Object end) {
    return new _RangeFilter(Operator.NOT_BETWEEN, fieldName, [start, end]);
  }

  static Filter and(List<Filter> filters) {
    return new _LogicalFilter(Operator.AND, filters);
  }

  static Filter or(List<Filter> filters) {
    return new _LogicalFilter(Operator.OR, filters);
  }

  static Filter not(List<Filter> filters) {
    return new _LogicalFilter(Operator.NOT, filters);
  }
}


class SimpleFilter extends Filter{

  static final NAME_PATTERN = RegExp(r'\\w+(\\.\\w+)*');

  SimpleFilter(this.operator, this.fieldName, this.value);

  final String fieldName;
  final Operator operator;
  final Object value;

  String get sqlOperator => toSqlOperator(operator);

  String getOperand() {
    if (fieldName.indexOf('::') > -1) {
      //return JsonFunction.fromPath(name).toString();
    }

    if (!NAME_PATTERN.hasMatch(fieldName)) {
      throw new ArgumentError('Invalid field name: ' + fieldName);
    }

    return 'self.' + fieldName;
  }



  @override
  String getQuery() {
    return '(${getOperand()} $sqlOperator ?)';
  }

  @override
  List<Object> getParams() {
    return [value];
  }

}

class _NullFilter extends SimpleFilter{
  _NullFilter(Operator operator, String fieldName) :
        super(operator, fieldName, null);

  factory _NullFilter.isNull(String fieldName) {
    return new _NullFilter(Operator.IS_NULL, fieldName);
  }

  factory _NullFilter.isNotNull(String fieldName) {
    return new _NullFilter(Operator.NOT_NULL, fieldName);
  }

  @override
  List<Object> getParams() => List.empty(growable: false);
}

class _LikeFilter extends SimpleFilter {
  static final DOT_PATTERN = RegExp(r'(^%.*)|(.*%\$)');
  static final bool isUnaccentEnabled = false;

  _LikeFilter(Operator operator, String fieldName, String value) :
        super(operator, fieldName, value);

  factory _LikeFilter.like(String fieldName, Object value) {
    return new _LikeFilter(Operator.LIKE, fieldName, format(value));
  }

  factory _LikeFilter.notLike(String fieldName, Object value) {
    return new _LikeFilter(Operator.NOT_LIKE, fieldName, format(value));
  }

  static String format(Object value) {
    String text = value.toString().toUpperCase();
    if (DOT_PATTERN.hasMatch(text)) {
      return text;
    }
    return text = '%$text%';
  }


  @override
  String getQuery() {
    if (isUnaccentEnabled) {
      return '(unaccent(UPPER(${getOperand()})) %s unaccent(${sqlOperator}))';
    }
    return '(UPPER(${getOperand()}) ${sqlOperator} ?)';
  }
}

class _RangeFilter extends SimpleFilter {

  Iterable<dynamic> values;

  _RangeFilter(Operator operator, String fieldName, Object value) :
        super(operator, fieldName, value){

    if (!(value is Iterable)) {
      throw new ArgumentError('Range filter should be a list');
    }

    values = value as Iterable<dynamic>;
  }

  @override
  String getQuery() {

    if (operator == Operator.BETWEEN || operator == Operator.NOT_BETWEEN) {
      return '(${getOperand()} ${sqlOperator} ? AND ?)';
    }

    List<String> sb = [getOperand()]
    ..add(' ')..add(sqlOperator)..add(' (');

    Iterator iter = values.iterator;
    iter.moveNext();
    iter.current;
    sb.add('?');
    while (iter.moveNext()) {
      sb.add(', ');
      sb.add('?');
      iter.current;
    }

    sb.add(')');
    return sb.toString();
  }

  @override
  List<Object> getParams() {
    return List.of(values);
  }
}

class _SQLFilter extends Filter {

  String jpql;

  List params;

  _SQLFilter(this.jpql, this.params) ;

  @override
  String getQuery() {
    return '(' + this.jpql + ')';
  }

  @override
  List<Object> getParams() {
    return List.of(params);
  }
}

class _LogicalFilter<T extends Model> extends Filter<T> {

  Operator operator;
  List<Filter> filters;

  _LogicalFilter(this.operator, this.filters) ;

  @override
  Query<T> build(String klass) {
    return new _LogicalFilterQuery<T>(klass, this).doFilter();
  }

  @override
  String getQuery() {
    if (filters == null || filters.isEmpty) return '';

    final List<String> filterParts = filters.map((f) => f.toString())
        .where(_notBlank).toList();

    StringBuffer sb = new StringBuffer();

    if (operator == Operator.NOT) sb.write('NOT ');

    if (filterParts.length > 1) sb.write('(');

    String joiner = operator == Operator.NOT ? ' AND ' : ' ' + toSqlOperator(operator) + ' ';
    sb.write(filterParts.join(joiner));

    if (filterParts.length > 1) sb.write(')');

    return sb.toString();
  }

  @override
  List<Object> getParams() {
    List<Object> params = [];
    for (Filter filter in filters) {
      params.addAll(filter.getParams());
    }
    return params;
  }

}

class _LogicalFilterQuery<T extends Model> extends Query<T> {

  _LogicalFilter<T> logicalFilter;
  _LogicalFilterQuery(String beanClass, this.logicalFilter)
      :super(beanClass);

  Query<T> doFilter() {
    Function queryTransform;
    Operator joinOperator;

    if (Operator.NOT == logicalFilter.operator) {
      queryTransform = (String query) => toSqlOperator(Operator.NOT) + ' ' + query;
      joinOperator = Operator.AND;
    } else {
      queryTransform = (String query) => query;
      joinOperator = logicalFilter.operator;
    }

    final String filterString =
    logicalFilter.filters.where((filterItem) => _notBlank(filterItem.toString()))
        .map((filterItem) => joinHelper.parse(
          queryTransform(filterItem.toString()),
          logicalFilter.translate || filterItem.translate))
          .join(' ${toSqlOperator(joinOperator)} ');

    if (_notBlank(filterString)) {
      //setFilter(fixPlaceholders(filterString));
      setParams(logicalFilter.getParams());
    }

    return this;
  }
}