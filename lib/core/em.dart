import 'commands.dart';

abstract class EM{

  Future<Result<E>> get<E>(String model, GetCommand request);
  Future<ListResult<E>> all<E>(String model, [ListCommand options]);
  Future<List<E>> getMani<E>(String model, GetManyCommand request);

  Future<Result<E>> create<E>(String model, SaveCommand request);
  Future<Result<E>> createBulk<E>(String model, SaveBulkCommand request);

  Future<Result<E>> update<E>(String model, SaveCommand request);
  Future<Result<E>> updateBulk<E>(String model, SaveBulkCommand request);

  Future<Result<E>> delete<E>(String model, DeleteCommand request);

  Future<ActionResult<E>> doAction<E>(String model, ActionCommand request);

  E newEntity<E>(String model, [Map<String, dynamic> data]);
  E copy<E>(String model, E entity);
  E clone<E>(String model, E entity);

}