


enum Operator {
  AND,
  OR,
  NOT,
  EQ,
  NOT_EQ,
  LT,
  GT,
  LT_EQ,
  GT_EQ,
  LIKE,
  NOT_LIKE,
  IS_NULL,
  NOT_NULL,
  IN,
  NOT_IN,
  BETWEEN,
  NOT_BETWEEN,

}
Map<String, String> _OPS = {
  "AND": "and",
  "OR": "or",
  "NOT": "not",
  "EQ": "=",
  "NEQ": "!=",
  "LT": "<",
  "GT": ">",
  "LT_EQ": "<=",
  "GT_EQ": ">=",
  "LIKE": "LIKE",
  "NOT_LIKE": "NOT LIKE",
  "IS_NULL": "IS NULL",
  "NOT_NULL": "IS NOT NULL",
  "IN": "IN",
  "NOT_IN": "NOT IN",
  "BETWEEN": "BETWEEN",
  "NOT_BETWEEN": "NOT BETWEEN",
};
Map<String, Operator> _NAME_OPS = {
  for (Operator operator in Operator.values)
    operator.name: operator,

  for (Operator operator in Operator.values)
    _OPS[operator.name]: operator,

};


Operator getOperator(String name) {
  Operator op = _NAME_OPS[name];
  if (op == null)
    throw ArgumentError("No such operator: " + name);

  return op;
}

String toSqlOperator(Operator op){
  return _OPS[op.name];
}

