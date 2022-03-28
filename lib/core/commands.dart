import 'dart:async';

import 'filters.dart';

class GetCommand {
  GetCommand({this.id, this.context, this.fields});
  final dynamic id;
  final Map<String, dynamic> context;
  final List<String> fields;
}

class GetManyCommand {
  GetManyCommand({this.ids, this.context, this.fields, this.sortOrder});
  final List<dynamic> ids;
  final Map<String, dynamic> context;
  final List<String> fields;
  final String sortOrder;
}

class ListCommand {
  ListCommand({this.offset, this.limit, this.context, this.filter, this.fields, this.sortOrder});

  final int offset;
  final int limit;
  final Filter filter;
  final Map<String, dynamic> context;
  final List<String> fields;
  final String sortOrder;
}

class ActionCommand {
  ActionCommand({this.action, this.data, this.context});
  final String action;
  final dynamic data;
  final Map<String, dynamic> context;
}

class SaveCommand {
  SaveCommand({this.data, this.fields, this.context});
  final Map<String, dynamic> data;
  final Map<String, dynamic> context;
  final List<String> fields;
}

class SaveBulkCommand {
  SaveBulkCommand({this.data, this.fields, this.context});
  final List<Map<String, dynamic>> data;
  final Map<String, dynamic> context;
  final List<String> fields;
}

class DeleteCommand {
  DeleteCommand(this.data, [this.context]);
  final dynamic data;
  final Map<String, dynamic> context;
}

class Error {

}

class Result<E>{
  Result({this.value, this.error, this.context, this.completer});
  final E value;
  final Error error;
  final Map<String, dynamic> context;
  final Completer<Function> completer;

}

class ActionResult<E> extends Result<E>{
  ActionResult({E value, Completer<Function> completer, Error error, Map<String, dynamic> context}):
        super(value:value, completer:completer, error:error, context:context);
}

class ListResult<E> extends Result<List<E>>{
  ListResult({this.totalCount, Completer<Function> completer, List<E> value, Error error, Map<String, dynamic> context})
      : super(value:value, completer:completer, error:error, context:context);
  final int totalCount;
}

class SaveResult<E> extends Result<E>{
  SaveResult({E value, Completer<Function> completer, Error error, Map<String, dynamic> context}):
        super(value:value, completer:completer, error:error, context:context);
}

class SaveBulkResult<E> extends Result<E>{
  SaveBulkResult({E value, Completer<Function> completer, Error error, Map<String, dynamic> context}):
        super(value:value, completer:completer, error:error, context:context);
}

class DeleteResult<E> extends Result<E>{
  DeleteResult({Error error, Completer<Function> completer, Map<String, dynamic> context}):
        super(completer:completer, error:error, context:context);
}
