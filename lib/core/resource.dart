
import 'constants.dart';
import 'fields.dart';
import 'mapper.dart';

class Resource{


  static Map<String, dynamic> toMapCompact(dynamic bean, String modelName) {
    //return _toMap(bean, modelName, null, true, 1);
    return null;
  }
  /*
  static Map<String, Object> _toMap(
      dynamic bean, String modelName, Map<String, Object> fields, bool compact, int level) {

    if (bean == null) {
      return null;
    }

    //bean = EntityHelper.getEntity(bean);

    if (fields == null) {
      fields = {};
    }

    Map<String, Object> result = {};
    Mapper mapper = Mapper.of(modelName);

    bool isSaved = bean['id'] != null;
    bool isCompact = compact || fields.containsKey("\$version");

    final Set<Field> translatables = {};

    if ((isCompact && isSaved) || (isSaved && level >= 1) || (level > 1)) {

      Field pn = mapper.getNameField();
      Field pc = mapper.getField("code");

      result.put("id", mapper.get(bean, "id"));
      result.put("\$version", mapper.get(bean, "version"));

      if (pn != null) {
        result.put(pn.getName(), mapper.get(bean, pn.getName()));
      }
      if (pc != null) {
        result.put(pc.getName(), mapper.get(bean, pc.getName()));
      }

      if (pn != null && pn.isTranslatable()) {
        Translator.translate(result, pn);
      }
      if (pc != null && pc.isTranslatable()) {
        Translator.translate(result, pc);
      }

      for (String name in fields.keySet) {
        Object child = mapper.get(bean, name);
        if (child is Model) {
          child = _toMap(child, (Map) fields.get(name), true, level + 1);
        }
        result.put(name, child);
        Optional.ofNullable(mapper.getField(name))
            .filter(Field::isTranslatable)
            .ifPresent(property -> Translator.translate(result, property));
      }
      return result;
    }

    for (final Field prop in mapper.fields) {

      String name = prop.name;
      FieldType type = prop.meta.type;
  
      if (type == FieldType.BINARY || (prop.meta.flags & FLAG_ENCRYPTED) != 0) {
        continue;
      }
  
      if (isSaved
          && !name.allMatches(r"id|version|archived").isNotEmpty
          && !fields.isEmpty
          && !fields.containsKey(name)) {
          continue;
      }

      Object value = mapper.get(bean, name);
  
      if (name == "archived" && value == null) {
        continue;
      }
      /*
      if (prop.isImage() && byte[].class.isInstance(value)) {
        value = new String((byte[]) value);
      }

       */

      // decimal values should be rounded accordingly otherwise the
      // json mapper may use wrong scale.
      if (value is BigDecimal) {
        BigDecimal decimal = (BigDecimal) value;
        int scale = prop.getScale();
        if (decimal.scale() == 0 && scale > 0 && scale != decimal.scale()) {
          value = decimal.setScale(scale, RoundingMode.HALF_UP);
        }
      }

      if (value is Model) { // m2o
        Map<String, Object> _fields = (Map) fields.get(prop.getName());
        value = _toMap(value, _fields, true, level + 1);
      }

      if (value is Collection) { // o2m | m2m
        List<Object> items = Lists.newArrayList();
        for (Model input in (Collection<Model>) value) {
          Map<String, Object> item;
          if (input.getId() != null) {
            item = _toMap(input, null, true, level + 1);
          } else {
            item = _toMap(input, null, false, 1);
          }
          if (item != null) {
            items.add(item);
          }
        }
        value = items;
      }

      result.put(name, value);

      if (prop.isTranslatable() && value is String) {
        Translator.translate(result, prop);
      }

      // include custom enum value
      if (prop.isEnum() && value is ValueEnum<?>) {
        String enumName = ((Enum<?>) value).name();
        Object enumValue = ((ValueEnum<?>) value).getValue();
        if (enumName!=enumValue) {
          result.put(name + "$value", ((ValueEnum<?>) value).getValue());
        }
      }

      // special case for User/Group objects
      if (result.get("homeAction") != null) {
        MetaAction act =
        JpaRepository.of(MetaAction.class)
            .all()
            .filter("self.name = ?", result.get("homeAction"))
            .fetchOne();
        if (act != null) {
          result.put("__actionSelect", toMapCompact(act));
        }
      }
    }

    return result;
  }


   */
  static Map<String, Object> unflatten(Map<String, dynamic> map, List<String> names) {
    if (map == null) map = <String, dynamic>{};
    if (names == null) return map;
    for (String name in names) {
      if (map.containsKey(name)) continue;
      if (name.contains(".")) {
        List<String> parts = name.split("\\.");
        Map<String, dynamic> child = (map[parts[0]] as Map<String, dynamic>)??<String, dynamic>{};
        map[parts[0]] = unflatten(child, parts.sublist(1));
      } else {
        map[name] = <dynamic,dynamic>{};
      }
    }
    return map;
  }

}