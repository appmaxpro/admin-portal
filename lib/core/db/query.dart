
import '../resource.dart';

import '../index.dart';
import 'package:invoiceninja_flutter/utils/strings.dart';

/**
 * The {@code Query} class allows filtering and fetching records quickly.
 *
 * <p>It also provides {@link #update(Map)} and {@link #delete()} method to perform mass update and
 * delete operation on matched records.
 */

bool _notBlank(String st) => st != null && st.isNotEmpty;

class Query<T extends Model> {

  String modelName;

  String filter;

  List<Object> params;

  Map<String, Object> namedParams;

  String orderBy;

  List<String> orderNames;

  JoinHelper joinHelper;

  bool _cacheable = false;

  bool readOnly = false;

  bool translate = false;

  static final RegExp NAME_PATTERN = RegExp(r'self\\.((?:[a-zA-Z_]\\w+)(?:(?:\\[\\])?\\.\\w+)*)');

  static final RegExp PLACEHOLDER_PLAIN = RegExp(r'(?<!\\?)\\?(?!(\\d+|\\?))');
  static final RegExp PLACEHOLDER_INDEXED = RegExp(r'\\?\\d+');

  ///
  /// Create a new instance of {@code Query} with given bean class.
  ///
  /// @param modelName model bean class
  ///
  Query(this.modelName, {this.orderBy = '', this.orderNames = const []}):
        joinHelper = new JoinHelper(modelName);

  factory Query.of(String name) {
    return Query<T>(name);
  }
  /*
  EntityManager em() {
    return JPA.em();
  }

   */

  JoinHelper getJoinHelper() {
    return joinHelper;
  }

  String getFilter() {
    return filter;
  }

  List<Object> getParams() {
    return params;
  }

  void setParams(List<Object> params) {
    this.params = params;
  }

  Map<String, Object> getNamedParams() {
    return namedParams;
  }

  void setNamedParams(Map<String, Object> namedParams) {
    this.namedParams = namedParams;
  }

  /**
   * A convenient method to filter the query using JPQL's <i>where</i> clause.
   *
   * <p>The filter string should refer the field names with {@code self.} prefix and values should
   * not be embedded into the filter string but should be passed by parameters and {@code ?}
   * placeholder should be used to mark parameter substitutions.
   *
   * <p>Here is an example:
   *
   * <pre>
   * Query&lt;Person&gt; query = Query.of(Person);
   * query = query.filter(&quot;self.name = ? AND self.age &gt;= ?&quot;, &quot;some&quot;, 20);
   *
   * List&lt;Person&gt; matched = query.fetch();
   * </pre>
   *
   * <p>This is equivalent to:
   *
   * <pre>
   * SELECT self from Person self WHERE (self.name = ?1) AND (self.age &gt;= ?2)
   * </pre>
   *
   * <p>The params passed will be added as positional parameters to the JPA query object before
   * performing {@link #fetch()}.
   *
   * @param filter the filter string
   * @param params the parameters
   * @return the same instance
   */
  Query<T> setFilter(String filter, [List<Object> params]) {
    if (this.filter != null) {
      throw new ArgumentError('Query is already filtered.');
    }
    if (filter == null || filter.isEmpty) {
      throw new ArgumentError('filter string is required.');
    }

    // check for mixed style positional parameters
    if (PLACEHOLDER_PLAIN.allMatches(filter).isNotEmpty &&
        PLACEHOLDER_INDEXED.allMatches(filter).isNotEmpty) {
      throw new ArgumentError(
          'JDBC and JPA-style positional parameters can\'t be mixed: $filter');
    }
    this.params = params;
    if (params != null) {
      this.filter = joinHelper.parse(filter, translate);
    } else {
      this.filter = filter;
    }

    return this;
  }


  /**
   * Set order by clause for the query. This method can be chained to provide multiple fields.
   *
   * <p>The {@code spec} is just a field name for {@code ASC} or should be prefixed with {@code -}
   * for {@code DESC} clause.
   *
   * <p>For example:
   *
   * <pre>
   * Query&lt;Person&gt; query = Query.of(Person);
   * query = query.filter(&quot;name =&quot;, &quot;some&quot;).filter(&quot;age &gt;=&quot;, 20)
   *        .filter(&quot;lang in&quot;, &quot;en&quot;, &quot;hi&quot;);
   *
   * query = query.order(&quot;name&quot;).order(&quot;-age&quot;);
   * </pre>
   *
   * <p>This is equivalent to:
   *
   * <pre>
   * SELECT p from Person p WHERE (p.name = ?1) AND (p.age &gt;= ?2) AND (lang IN (?3, ?4)) ORDER BY p.name, p.age DESC
   * </pre>
   *
   * @param spec order spec
   * @return the same query instance
   */
  Query<T> order(String spec) {
    if (orderBy.length > 0) {
      orderBy += ', ';
    } else {
      orderBy = ' ORDER BY ';
    }

    String name = spec.trim();

    if (name[0] == '-') {
      name = this.joinHelper.joinName(name.substring(1), true, translate);
      orderBy += name + ' DESC';
    } else {
      name = this.joinHelper.joinName(name, true, translate);
      orderBy += name;
    }

    orderNames.add(name);

    return this;
  }

  /**
   * Set the query result cacheable.
   *
   * @return the same query instance
   */
  Query<T> setCacheable([bool value=true]) {
    this._cacheable = value;
    return this;
  }

  bool get cacheable => _cacheable;


  /**
   * Set the query readonly.
   *
   * @return the same query instance.
   */
  Query<T> setReadOnly([bool value=true]) {
    this.readOnly = value;
    return this;
  }

  /**
   * Set whether to use translation join.
   *
   * @param translate
   * @return
   */
  Query<T> setTranslate([bool value=true]) {
    this.translate = value;
    return this;
  }


  Query<T> autoFlush(bool auto) {
    //this.flushMode = auto ? FlushModeType.AUTO : FlushModeType.COMMIT;
    return this;
  }


  /**
   * Fetch the matched records within the given range.
   *
   * @param limit the limit
   * @param offset the offset
   * @return list of matched records within the range
   */
  Future<List<T>> fetch([int limit=0, int offset=0]) {

    ///final TypedQuery<T> query = em().createQuery(selectQuery(), modelName);
    //     if (limit > 0) {
    //       query.setMaxResults(limit);
    //     }
    //     if (offset > 0) {
    //       query.setFirstResult(offset);
    //     }
    //
    //     final QueryBinder binder = this.bind(query).opts(cacheable, flushMode);
    //     if (readOnly) {
    //       binder.setReadOnly();
    //     }
    //     return query;
    return Future.value([]);
  }

  /**
   * Fetch a matched record at the given offset.
   *
   * @param offset the offset
   * @return the matched record at given offset
   */
  Future<T> fetchOne([int offset=0]) {
    return fetch(1, offset).then((value) => value.isNotEmpty ? value.first : null);
  }

  /**
   * Returns the number of total records matched.
   *
   * @return total number
   */
  Future<int> count() {
    String countQuery = this.countQuery();
    int result = 0;
    //final TypedQuery<Long> query = em().createQuery(countQuery(), Long.class);
    //query.setHint(QueryHints.HINT_PASS_DISTINCT_THROUGH, false);
    //this.bind(query).setCacheable(cacheable).setFlushMode(flushMode).setReadOnly();
    return Future.value(result);
  }

  /**
   * Return a selector to select records with specific fields only.
   *
   * @param names field names to select
   * @return a new instance of {@link Selector}
   */
  Selector select(List<String> names) {
    return new Selector(names, this);
  }

  /**
   * Perform mass update on matched records with the given values.
   *
   * <p>If <code>updatedBy</code> user is null, perform non-versioned update otherwise performed
   * versioned update.
   *
   * @param values the key value map
   * @param updatedBy the user to set 'updatedBy' field
   * @return total number of records updated
   */
  int update(Map<String, Object> values, [dynamic updatedBy]) {
    if (values == null || values.isEmpty) {
      return 0;
    }

    final Map<String, Object> params = {};
    final Map<String, Object> namedParams = {};
    final List<String> where = [];

    if (this.namedParams != null) {
      namedParams.addAll(this.namedParams);
    }

    for (final MapEntry<String, Object> entry in values.entries) {
      final String name = entry.key.replaceFirst(r'^self\\.', '');
      params[name] = entry.value;
      if (entry.value == null) {
        where.add('self.$name IS NOT NULL');
      } else {
        where.add('(self.$name IS NULL OR self.$name != :name)');
      }
    }
    /*
    if (updatedBy != null && AuditableModel.class.isAssignableFrom(modelName)) {
      params.put('updatedBy', updatedBy);
      params.put('updatedOn', LocalDateTime.now());
    }

     */

    namedParams.addAll(params);

    bool versioned = updatedBy != null;
    bool notMySQL = true;//!DBHelper.isMySQL();

    final String whereClause = where.join(' OR ');
    String selectQuery = this.selectQuery(true).replaceFirst('SELECT self', 'SELECT self.id');

    if (selectQuery.contains(' WHERE ')) {
      selectQuery = selectQuery.replaceFirst(' WHERE ', ' WHERE ($whereClause) AND (') + ')';
    } else {
      selectQuery = '$selectQuery WHERE $whereClause';
    }

    selectQuery = selectQuery.replaceAll(r'\\bself', 'that');
    int count = 0;
    if (notMySQL) {
      /*
      return QueryBinder.of(
              em().createQuery(updateQuery(params, versioned, 'self.id IN (${selectQuery})')))
          .bind(namedParams, this.params)
          .getQuery()
          .executeUpdate();

       */
      return count;
    }

    // MySQL doesn't allow sub select on same table with UPDATE also, JPQL doesn't
    // support JOIN with UPDATE query so we have to update in batch.

    //String updateQueryStr = updateQuery(params, versioned, 'self.id IN (:ids)');
    //
    //     int count = 0;
    //     int limit = 1000;
    //
    //     TypedQuery<Long> sq = em().createQuery(selectQuery, Long.class);
    //     javax.persistence.Query uq = em().createQuery(updateQueryStr);
    //
    //     QueryBinder.of(sq).bind(namedParams, this.params);
    //     QueryBinder.of(uq).bind(namedParams, this.params);
    //
    //     sq.setFirstResult(0);
    //     sq.setMaxResults(limit);
    //
    //     List<dynamic> ids = sq.getResultList();
    //     while (ids.isNotEmpty) {
    //       uq.setParameter('ids', ids);
    //       count += uq.executeUpdate();
    //       ids = sq.getResultList();
    //     }

    return count;
  }

  /**
   * Bulk delete all the matched records. <br>
   * <br>
   * This method uses <code>DELETE</code> query and performs {@link
   * javax.persistence.Query#executeUpdate()}.
   *
   * @see #remove()
   * @return total number of records affected.
   */
  int delete() {
    bool notMySQL = true;//!DBHelper.isMySQL();
    String selectQuery = this.selectQuery(true)
        .replaceFirst(r'SELECT self', 'SELECT self.id')
        .replaceAll(r'\\bself', 'that');
    int count = 0;
    if (notMySQL) {
      //javax.persistence.Query q = em().createQuery(deleteQuery('self.id IN (' + selectQuery + ')'));
      //this.bind(q);
      //return q.executeUpdate();
      return 0;
    }

    // MySQL doesn't allow sub select on same table with DELETE also, JPQL doesn't
    // support JOIN with DELETE query so we have to update in batch.

    //TypedQuery<Long> sq = em().createQuery(selectQuery, Long.class);
    //     javax.persistence.Query dq = em().createQuery(deleteQuery('self.id IN (:ids)'));
    //
    //     this.bind(sq);
    //     this.bind(dq);
    //
    //     int count = 0;
    //     int limit = 1000;
    //
    //     sq.setFirstResult(0);
    //     sq.setMaxResults(limit);
    //
    //     List<dynamic> ids = sq.getResultList();
    //     while (ids.isNotEmpty) {
    //       dq.setParameter('ids', ids);
    //       count += dq.executeUpdate();
    //       ids = sq.getResultList();
    //     }

    return count;
  }

  /**
   * Remove all the matched records. <br>
   * <br>
   * In contrast to the {@link #delete()} method, it performs {@link EntityManager#remove(Object)}
   * operation by fetching objects in pages (100 at a time).
   *
   * @see #delete()
   * @return total number of records removed.
   */
  int remove() {
    return 0;
  }

  String selectQuery([bool update=false]) {
    StringBuffer sb =
        new StringBuffer('SELECT self FROM ')
            ..write(modelName)
            ..write(' self')
            ..write(joinHelper.toString(!update));
    if (filter != null && filter.trim().isNotEmpty) sb..write(' WHERE ')..write(filter);
    if (update) {
      return sb.toString();
    }
    sb.write(orderBy);
    return joinHelper.fixSelect(sb.toString());
  }

  String countQuery() {
    StringBuffer sb =
        new StringBuffer('SELECT COUNT(self.id) FROM ')
            ..write(modelName)
            ..write(' self')
            ..write(joinHelper.toString(false));
    if (filter != null && filter.trim().isNotEmpty) sb..write(' WHERE $filter');
    return joinHelper.fixSelect(sb.toString());
  }

  String updateQuery(Map<String, Object> values, bool versioned, String filter) {
    final String items =
        values.entries.
            map((MapEntry<String, Object> entry) => 'self.${entry.key} = :${entry.key}')
            .join(', ');

    final StringBuffer sb = StringBuffer()
        ..write('UPDATE ')
        ..write(versioned ? 'VERSIONED ' : '')
        ..write(modelName)
        ..write(' self')
        ..write(' SET ')
        ..write(items);

    if (_notBlank(filter)) {
      sb
      ..write(' WHERE $filter');
    }

    return sb.toString();
  }

  String deleteQuery(String filter) {
    final StringBuffer sb =
        new StringBuffer('DELETE FROM $modelName self');
    if (_notBlank(filter)) {
      sb..write(' WHERE ')..write(filter);
    }
    return sb.toString();
  }
  /*
  QueryBinder bind(javax.persistence.Query query) {
    return QueryBinder.of(query).bind(namedParams, params);
  }

   */

  /**
   * Bind the named parameters of the query with the given values. Named parameter must me set after
   * query is filtered.
   * Bind the given named parameter of the query with the given value.
   * @param params mapping for named params.
   * @return the same instance
   */
  Query<T> bind([Map<String, Object> params, String name, Object value]) {
    if (namedParams == null) {
      namedParams = {};
    }
    if (name != null) {
      namedParams[name] = value;
    }
    if (params != null) {
      namedParams.addAll(params);
    }
    return this;
  }

  @override
  String toString() {
    return selectQuery();
  }

}

/**
* A helper class to select specific field values. The record is returned as a Map object with the
* given names as keys.
* = value;
  return this.b
* <pre>
* List&lt;Map&gt; data = Contact.all().filter(&quot;self.age &gt; ?&quot;, 20)
*        .select(&quot;title.name&quot;, &quot;fullName&quot;, &quot;age&quot;).fetch(80, 0);
* </pre>
*
* This results in following query:
*
* <pre>
* SELECT _title.name, self.fullName JOIN LEFT self.title AS _title WHERE self.age &gt; ? LIMIT 80
* </pre>
*
* The {@link Selector#fetch(int, int)} method returns a List of Map instead of the model object.
*/
class Selector {

    List<String> names = ['id', 'version'];
    List<String> collections = [];
    String query;
    Mapper mapper;
    Query q;
    Selector(List<String> names, this.q) {
      mapper = Mapper.of(q.modelName);
      List<String> selects = [];
      selects.add('self.id');
      final hasVersion = mapper.getField('version') != null;
      if (hasVersion)
        selects.add('self.version');
      for (String name in names) {
        Field property = getField(name);
        if (property != null
            && property.meta.type != FieldType.BINARY
            && !property.meta.transient
            && !hasTransientParent(name)) {
          String alias = q.joinHelper.joinName(name);
          if (alias != null) {
            selects.add(alias);
            this.names.add(name);
          } else {
            collections.add(name);
          }

          // select id,version,name field for m2o
          if (property.target != null) {
            this.names.add(name + '.id');
            if (hasVersion)
              this.names.add('$name.version');
            this.names.add('$name.${property.target}');
            selects.add(q.joinHelper.joinName('$name.id'));
            if (hasVersion)
              selects.add(q.joinHelper.joinName('$name.version'));
            selects.add(q.joinHelper.joinName('$name.${property.target}'));
          }
        } else if (name.indexOf('.') > -1) {
          /*
          final JsonFunction func = JsonFunction.fromPath(name);
          final Field json = mapper.getField(func.getField());
          if (json != null && json.isJson()) {
            this.names.add(func.getField() + '.' + func.getAttribute());
            selects.add(func.toString());
          }

           */
        }
      }

      if (q.joinHelper.hasCollection) {
        q.orderNames.where((String n) => !selects.contains(n)).forEach(selects.add);
      }

      StringBuffer sb =
            StringBuffer('SELECT')
              ..write(' new List(${selects.join(', ')})')
              ..write(' FROM ')
              ..write(q.modelName)
              ..write(' self')
              ..write(q.joinHelper.toString(false));
      if (q.filter != null && q.filter.trim().length > 0) sb..write(' WHERE ${q.filter}');
      sb.write(q.orderBy);
      query = q.joinHelper.fixSelect(sb.toString());
    }

    bool hasTransientParent(String fieldName) {
      final List<String> fieldNameParts = fieldName.split('.');

      for (int i = 1; i < fieldNameParts.length; ++i) {
        final String name = fieldNameParts.sublist(0, i).join('.');
        final Field property = getField(name);
        if (property != null && property.meta.transient) {
          return true;
        }
      }

      return false;
    }

    Field getField(String field) {
      if (field == null || field.trim().isEmpty) return null;
      Mapper mapper = this.mapper;
      Field property = null;
      Iterator<String> names = field.split('.').iterator;
      while (names.moveNext()) {
        property = mapper.getField(names.current);
        if (property == null) return null;
        if (names.moveNext()) {
          if (property.target == null) return null;
          mapper = Mapper.of(property.target);
        }
      }
      return property;
    }

    List<List> values(int limit, int offset) {
      /*
      javax.persistence.Query q = em().createQuery(query);
      if (limit > 0) {
        q.setMaxResults(limit);
      }
      if (offset > 0) {
        q.setFirstResult(offset);
      }

      final QueryBinder binder = q.bind(q).opts(cacheable, flushMode);
      if (q.readOnly) {
        binder.setReadOnly();
      }

      return q.getResultList();

       */
      return [];
    }

    List<Map> fetch(int limit, int offset) {

      List<List> data = values(limit, offset);
      List<Map> result = [];

      for (List items in data) {
        Map<String, Object> map = {};
        for (int i = 0; i < names.length; i++) {
          Object value = items[i];
          String name = names[i];
          Field property = getField(name);

          // in case of m2o, get the id,version,name tuple
          if (property != null && property.target != null) {
            value = getReferenceValue(items, i);
            i += 3;
          } else if (value is Model) {
            value = Resource.toMapCompact(value, property.target);
          }
          map[name] = value;
        }
        if (collections.length > 0) {
          map.addAll(this.fetchCollections(items[0]));
        }
        result.add(map);
      }

      return result;
    }

    Object getReferenceValue(List<dynamic> items, int at) {
      if (names[at] == null && names[at + 1]== null) {
        return null;
      }
      Map<String, Object> value = {};
      String name = names[at];
      String nameField = names[at + 3].replaceAll('${name}.', '');
      value.addAll({
        'id': items[at + 1],
        '\$version': items[at + 2],
        nameField: items[at + 3],
      });

      return value;
    }

    Map<String, List> fetchCollections(Object id) {
      Map<String, List> result = {};
      //Object self = JPA.em().find(q.modelName, id);
      Object self = null;
      for (String name in collections) {

        Iterable<Model> items = mapper.get(self, name) as Iterable<Model>;
        if (items != null) {
          List<Map<String, dynamic>> all = [];

          for (Model obj in items) {
            all.add(Resource.toMapCompact(obj, mapper.getField(name).target));
          }
          result[name] = all;
        }
      }
      return result;
    }

    @override
    String toString() {
      return query;
    }
 }



/**
* JoinHelper class is used to auto generate <code>LEFT JOIN</code> for association expressions.
*
* <p>For example:
*
* <pre>
*    Query<Contact> q = Contact.all().filter('self.title.code = ?1 OR self.age > ?2', 'mr', 20);
* </pre>
*
* Results in:
*
* <pre>
* SELECT self FROM Contact self LEFT JOIN self.title _title WHERE _title.code = ?1 OR self.age > ?2
* </pre>
*
* So that all the records are matched even if <code>title</code> field is null.
*/
class JoinHelper {

    String modelName;

    Map<String, String> joins = {};

    Set<String> translationJoins = {};

    Set<String> fetches = {};

    bool hasCollection;

    static final RegExp selectPattern =
            RegExp(r'^SELECT\\s+(COUNT\\s*\\()?', caseSensitive: false);

    static final RegExp pathPattern = Query.NAME_PATTERN;

    JoinHelper(this.modelName) ;

    /**
     * Parse the given filter string and return transformed filter expression.
     *
     * <p>Automatically calculate <code>LEFT JOIN</code> for association path expressions and the
     * path expressions are replaced with the join variables.
     *
     * @param filter the filter expression
     * @param translate whether to generate translation join
     * @return the transformed filter expression
     */
    String parse(String filter, bool translate) {

      String result = '';
      final Iterable<RegExpMatch> matcher = pathPattern.allMatches(filter);

      int last = 0;
      for (RegExpMatch matchResult in matcher) {
        String alias = joinName(matchResult.group(1), false, translate);
        alias ??= 'self.${matchResult.group(1)}';
        result += filter.substring(last, matchResult.start) + alias;
        last = matchResult.end;
      }
      if (last < filter.length)
          result += filter.substring(last);

      return result;
    }

    /**
     * Automatically generate <code>LEFT JOIN</code> for the given name (association path
     * expression) and return the join variable.
     *
     * @param name the path expression or field name
     * @param fetch whether to generate fetch join
     * @param translate whether to generate translation join
     * @return join variable if join is created else returns name
     */
    String joinName(String name, [bool fetch=false, bool translate=false]) {
      final Mapper mapper = Mapper.of(modelName);
      final List<String> path = name.split('\\.');
      String prefix;
      String variable = name;

      if (path.length > 1) {
        variable = path[path.length - 1];
        String joinOn;
        Mapper currentMapper = mapper;
        for (int i = 0; i < path.length - 1; i++) {
          final String item = path[i].replaceAll(r'[]', '');
          Field property = currentMapper.getField(item);
          if (property == null) {
            throw ArgumentError(
                'could not resolve property: ${item} of: ${modelName}');
          }

          if ((property.meta.flags & FLAG_JSON) != 0) {
            //return JsonFunction.fromPath(name).toString();
          }

          if (prefix == null) {
            joinOn = 'self.' + item;
            prefix = '_' + item;

            // Use at least one join fetch on collection,
            // so that we still get unique results when not passing distinct to SQL
            if (fetches.isEmpty && property.meta.isCollection) {
              fetches.add(joinOn);
            }
          } else {
            joinOn = prefix + '.' + item;
            prefix = prefix + '_' + item;
          }
          if (!joins.containsKey(joinOn)) {
            joins[joinOn] = prefix;
          }
          if (fetch) {
            fetches.add(joinOn);
          }

          if (property.target != null) {
            currentMapper = Mapper.of(property.target);
            if (property.meta.isCollection) {
               hasCollection = true;
            }
          }

          if (i == path.length - 2) {
            property = currentMapper.getField(variable);
            if (property == null) {
              throw new ArgumentError(
                      'No such field "$variable" in object '
                          '"${currentMapper.name}"');
            }
            if (property.meta.isReference) {
              joinOn = prefix + '.' + variable;
              prefix = prefix + '_' + variable;
              joins[joinOn] = prefix;
              if (fetch) {
                fetches.add(joinOn);
              }
              return prefix;
            }
            if (translate && (property.meta.flags & FLAG_TRANSLATE) != 0) {
              return this.translate(property, prefix);
            }
          }
        }
      } else {
        final Field property = mapper.getField(name);
        if (property == null) {
          throw new ArgumentError(
              'No such field "${variable}" in object "${modelName}"');
        }
        if (property.meta.isCollection) {
          return null;
        }
        if (property.target != null) {
          prefix = '_' + name;
          final String joinOn = 'self.' + name;
          joins[joinOn] = prefix;
          if (fetch) {
            fetches.add(joinOn);
          }
          return prefix;
        }

        if (translate && (property.meta.flags & FLAG_TRANSLATE) != 0) {
          return this.translate(property, null);
        }
      }
      prefix ??= 'self';

      return '$prefix.$variable';
    }

    String translate(Field property, String prefix) {
      final String variable = property.name;
      /*
      String language = I18n.getBundle().getLocale().getLanguage();
      String joinName =
          prefix == null
              ? '_meta_translation_${variable}'
              : '_meta_translation${prefix}_${variable}';
      String from = prefix == null ? 'self' : prefix;
      String join =
              'MetaTranslation ${joinName} ON ${joinName}.key = CONCAT('value:', ${from}.${variable}) AND ${joinName}.language = '${language}'';

      translationJoins.add(join);

      return 'COALESCE(NULLIF(${joinName}.message, ''), ${from}.${variable})';

       */
      String from = prefix == null ? 'self' : prefix;
      return '$from.$variable';
    }

    String fixSelect(String query) {
      if (hasCollection && selectPattern.hasMatch(query)){
        query = query.replaceFirst(r'\$0DISTINCT ', '');
      }
      return query;
    }

    @override
    String toString([bool fetch=true]) {
      
      final List<String> joinItems = [];
      for (final MapEntry<String, String> entry in joins.entries) {
        final String fetchString = fetch && fetches.contains(entry.key) ? ' FETCH' : '';
        joinItems.add(
            'LEFT JOIN$fetchString ${entry.key} ${entry.value}');
      }
      for (final String join in translationJoins) {
        joinItems.add('LEFT JOIN $join');
      }
      return joinItems.isEmpty ? '' : joinItems.join(' ');
    }
}