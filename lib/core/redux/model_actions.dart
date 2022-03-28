// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
//import 'dart:mirrors';

// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import '../index.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/design/design_selectors.dart';
import 'package:invoiceninja_flutter/ui/app/entities/entity_actions_dialog.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';
import 'package:invoiceninja_flutter/utils/dialogs.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

import '../states.dart';

//import 'package:http/http.dart' as http;
//import 'package:entityninja_flutter/data/web_client.dart';
//import 'package:printing/printing.dart';

class ViewModelList implements PersistUI {
  ViewModelList({this.force = false});

  final bool force;
}

class ViewModel implements PersistUI, PersistPrefs {
  ViewModel({this.entityId, this.force = false});

  final String entityId;
  final bool force;
}

class EditModel implements PersistUI, PersistPrefs {
  EditModel({
    this.entity,
    this.completer,
    this.entityItemIndex,
    this.force = false,
  });

  final Record entity;
  final int entityItemIndex;
  final Completer completer;
  final bool force;
}

class ShowEmailModel {
  ShowEmailModel({this.entity, this.context, this.completer});

  final Record entity;
  final BuildContext context;
  final Completer completer;
}

class ShowPdfModel {
  ShowPdfModel({this.entity, this.context, this.activityId});

  final Record entity;
  final BuildContext context;
  final String activityId;
}

class EditModelItem implements PersistUI {
  EditModelItem([this.entityItemIndex]);

  final int entityItemIndex;
}

class UpdateModel implements PersistUI {
  UpdateModel(this.entity);

  final Record entity;
}

class UpdateModelClient implements PersistUI {
  UpdateModelClient({this.client});

  final ClientEntity client;
}

class LoadModel {
  LoadModel({this.completer, this.entityId});

  final Completer completer;
  final String entityId;
}

class LoadModels {
  LoadModels({this.completer});

  final Completer completer;
}

class LoadModelRequest implements StartLoading {}

class LoadModelFailure implements StopLoading {
  LoadModelFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadModelFailure{error: $error}';
  }
}

class LoadModelSuccess implements StopLoading, PersistData {
  LoadModelSuccess(this.entity);

  final StateModel entity;

  @override
  String toString() {
    return 'LoadModelSuccess{entity: $entity}';
  }
}

class LoadModelsRequest implements StartLoading {}

class LoadModelsFailure implements StopLoading {
  LoadModelsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadModelsFailure{error: $error}';
  }
}

class LoadModelsSuccess implements StopLoading {
  LoadModelsSuccess(this.entitys);

  final ListResult entitys;

  @override
  String toString() {
    return 'LoadModelsSuccess{entitys: $entitys}';
  }
}

class AddModelContact implements PersistUI {
  AddModelContact({this.contact, this.invitation});

  final ContactEntity contact;
  final InvitationEntity invitation;
}

class RemoveModelContact implements PersistUI {
  RemoveModelContact({this.invitation});

  final InvitationEntity invitation;
}

class AddItem implements PersistUI {
  AddItem({this.entityItem});

  final Record entityItem;
}

class MoveItem implements PersistUI {

  MoveItem({
    this.oldIndex,
    this.newIndex,
  });

  final int oldIndex;
  final int newIndex;
}

class AddItems<Item> implements PersistUI {
  AddItems(this.lineItems);

  final List<Item> lineItems;
}

class UpdateItem implements PersistUI {
  UpdateItem({this.index, this.entityItem});

  final int index;
  final Record entityItem;
}

class DeleteItem implements PersistUI {
  DeleteItem(this.index);
  
  final int index;
}

class SaveModelRequest implements StartSaving {
  SaveModelRequest({
    this.completer,
    this.entity,
    this.entityAction,
  });

  final Completer completer;
  final Record entity;
  final EntityAction entityAction;
}

class SaveModelSuccess implements StopSaving, PersistUI {
  SaveModelSuccess(this.entity);

  final Record entity;
}

class AddModelSuccess implements StopSaving, PersistUI {
  AddModelSuccess(this.entity);

  final Record entity;
}

class SaveModelFailure implements StopSaving {
  SaveModelFailure(this.error);

  final Object error;
}

class EmailModelRequest implements StartSaving {
  EmailModelRequest(
      {this.completer, this.entityId, this.template, this.subject, this.body});

  final Completer completer;
  final String entityId;
  final EmailTemplate template;
  final String subject;
  final String body;
}

class EmailModelSuccess implements StopSaving, PersistData {
  EmailModelSuccess({@required this.entity});

  final Record entity;
}

class EmailModelFailure implements StopSaving {
  EmailModelFailure(this.error);

  final dynamic error;
}

class MarkModelsSentRequest implements StartSaving {
  MarkModelsSentRequest(this.completer, this.entityIds);

  final Completer completer;
  final List<String> entityIds;
}

class MarkModelsSentSuccess implements StopSaving, PersistData {
  MarkModelsSentSuccess(this.entitys);

  final List<Record> entitys;
}

class MarkModelsSentFailure implements StopSaving {
  MarkModelsSentFailure(this.error);

  final dynamic error;
}

class BulkEmailModelsRequest implements StartSaving {
  BulkEmailModelsRequest(this.completer, this.entityIds);

  final Completer completer;
  final List<String> entityIds;
}

class BulkEmailModelsSuccess implements StopSaving, PersistData {
  BulkEmailModelsSuccess(this.entitys);

  final List<Record> entitys;
}

class BulkEmailModelsFailure implements StopSaving {
  BulkEmailModelsFailure(this.error);

  final dynamic error;
}

class MarkModelsPaidRequest implements StartSaving {
  MarkModelsPaidRequest(this.completer, this.entityIds);

  final Completer completer;
  final List<String> entityIds;
}

class MarkModelsPaidSuccess implements StopSaving {
  MarkModelsPaidSuccess(this.entitys);

  final List<Record> entitys;
}

class MarkModelsPaidFailure implements StopSaving {
  MarkModelsPaidFailure(this.error);

  final dynamic error;
}

class CancelModelsRequest implements StartSaving {
  CancelModelsRequest(this.completer, this.entityIds);

  final Completer completer;
  final List<String> entityIds;
}

class CancelModelsSuccess implements StopSaving {
  CancelModelsSuccess(this.entitys);

  final List<Record> entitys;
}

class CancelModelsFailure implements StopSaving {
  CancelModelsFailure(this.error);

  final Object error;
}

class ArchiveModelsRequest implements StartSaving {
  ArchiveModelsRequest(this.completer, this.entityIds);

  final Completer completer;
  final List<String> entityIds;
}

class ArchiveModelsSuccess implements StopSaving, PersistData {
  ArchiveModelsSuccess(this.entitys);

  final List<Record> entitys;
}

class ArchiveModelsFailure implements StopSaving {
  ArchiveModelsFailure(this.entitys);

  final List<Record> entitys;
}

class DeleteModelsRequest implements StartSaving {
  DeleteModelsRequest(this.completer, this.entityIds);

  final Completer completer;
  final List<String> entityIds;
}

class DeleteModelsSuccess implements StopSaving, PersistData {
  DeleteModelsSuccess(this.entitys);

  final List<Record> entitys;
}

class DeleteModelsFailure implements StopSaving {
  DeleteModelsFailure(this.entitys);

  final List<Record> entitys;
}

class DownloadModelsRequest implements StartSaving {
  DownloadModelsRequest(this.completer, this.entityIds);

  final Completer completer;
  final List<String> entityIds;
}

class DownloadModelsSuccess implements StopSaving {}

class DownloadModelsFailure implements StopSaving {
  DownloadModelsFailure(this.error);

  final Object error;
}

class RestoreModelsRequest implements StartSaving {
  RestoreModelsRequest(this.completer, this.entityIds);

  final Completer completer;
  final List<String> entityIds;
}

class RestoreModelsSuccess implements StopSaving, PersistData {
  RestoreModelsSuccess(this.entitys);

  final List<Record> entitys;
}

class RestoreModelsFailure implements StopSaving {
  RestoreModelsFailure(this.entitys);

  final List<Record> entitys;
}

class FilterModels implements PersistUI {
  FilterModels(this.filter);

  final String filter;
}

class SortModels implements PersistUI, PersistPrefs {
  SortModels(this.field);

  final String field;
}

class FilterModelsByState implements PersistUI {
  FilterModelsByState(this.state);

  final EntityState state;
}

class FilterModelsByStatus implements PersistUI {
  FilterModelsByStatus(this.status);

  final EntityStatus status;
}

class FilterModelDropdown {
  FilterModelDropdown(this.filter);

  final String filter;
}

class FilterModelsByCustom1 implements PersistUI {
  FilterModelsByCustom1(this.value);

  final String value;
}

class FilterModelsByCustom2 implements PersistUI {
  FilterModelsByCustom2(this.value);

  final String value;
}

class FilterModelsByCustom3 implements PersistUI {
  FilterModelsByCustom3(this.value);

  final String value;
}

class FilterModelsByCustom4 implements PersistUI {
  FilterModelsByCustom4(this.value);

  final String value;
}

class StartModelMultiselect {}

class AddToModelMultiselect {
  AddToModelMultiselect({@required this.entity});

  final BaseEntity entity;
}

class RemoveFromModelMultiselect {
  RemoveFromModelMultiselect({@required this.entity});

  final BaseEntity entity;

  Object call(List<Object> arguments) {
    //InstanceMirror m = reflect(computer);
    return null;
  }

}

class ClearModelMultiselect {}

class SaveModelDocumentRequest implements StartSaving {
  SaveModelDocumentRequest({
    @required this.completer,
    @required this.multipartFile,
    @required this.entity,
  });

  final Completer completer;
  final MultipartFile multipartFile;
  final Record entity;
}

class SaveModelDocumentSuccess implements StopSaving, PersistData, PersistUI {
  SaveModelDocumentSuccess(this.document);

  final DocumentEntity document;
}

class SaveModelDocumentFailure implements StopSaving {
  SaveModelDocumentFailure(this.error);

  final Object error;
}

class UpdateModelTab implements PersistUI {
  UpdateModelTab({this.tabIndex});

  final int tabIndex;
}

void handleModelAction(BuildContext context, List<BaseEntity> entitys,
    EntityAction action) async {
  if (entitys.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final state = store.state;
  final localization = AppLocalization.of(context);
  final entity = entitys.first as Record;
  final entityIds = entitys.map((entity) => entity.id).toList();

  switch (action) {
    case EntityAction.edit:
      //editEntity(context: context, entity: entity);
      break;
    case EntityAction.viewPdf:
      store.dispatch(ShowPdfModel(entity: entity, context: context));
      break;
    case EntityAction.clientPortal:
      /*
      final invitationSilentLink = entity.get<String>('invitationSilentLink');
      if (await canLaunch(invitationSilentLink)) {
        await launch(invitationSilentLink,
            forceSafariVC: false, forceWebView: false);
      }
       */
      break;
    case EntityAction.markSent:
      store.dispatch(MarkModelsSentRequest(
          snackBarCompleter<Null>(
              context,
              entityIds.length == 1
                  ? localization.markedInvoiceAsSent
                  : localization.markedInvoicesAsSent),
          entityIds));


      break;
    case EntityAction.reverse:
      /*
      final designId = getDesignIdForClientByEntity(
          state: state,
          clientId: entity.get('clientId'),
          entityType: EntityType.credit);
      createEntity(
          context: context,
          entity: entity.clone.rebuild((b) => b
            ..entityId = entity.id
            ..entityType = EntityType.credit
            ..designId = designId));

       */
      break;

    case EntityAction.cancel:
      store.dispatch(CancelModelsRequest(
          snackBarCompleter<Null>(
              context,
              entityIds.length == 1
                  ? localization.cancelledInvoice
                  : localization.cancelledInvoices),
          entityIds));
      break;
    case EntityAction.markPaid:
      /*
      store.dispatch(MarkModelsPaidRequest(
          snackBarCompleter<Null>(
              context,
              entityIds.length == 1
                  ? localization.markedModelAsPaid
                  : localization.markedModelsAsPaid),
          entityIds));

       */
      break;
    case EntityAction.emailInvoice:
    case EntityAction.bulkEmailInvoice:

      break;
    case EntityAction.cloneToOther:
      //cloneToDialog(context: context, entity: entity);
      break;
    case EntityAction.clone:
      //createEntity(context: context, entity: entity.repo.clone(entity));
      break;
    case EntityAction.cloneToQuote:
      /*
      final designId = getDesignIdForClientByEntity(
          state: state,
          clientId: entity.clientId,
          entityType: EntityType.quote);
      createEntity(
          context: context,
          entity: entity.clone.rebuild((b) => b
            ..entityType = EntityType.quote
            ..designId = designId));

       */
      break;
    case EntityAction.cloneToCredit:
      /*
      final designId = getDesignIdForClientByEntity(
          state: state,
          clientId: entity.clientId,
          entityType: EntityType.credit);
      createEntity(
          context: context,
          entity: entity.clone.rebuild((b) => b
            ..entityType = EntityType.credit
            ..designId = designId));

       */
      break;
    case EntityAction.cloneToRecurring:
      /*
      createEntity(
          context: context,
          entity: entity.clone
              .rebuild((b) => b..entityType = EntityType.recurringModel));

       */
      break;
    case EntityAction.newPayment:
      /*
      createEntity(
        context: context,
        entity: PaymentEntity(state: state).rebuild((b) => b
          ..isForModel = true
          ..clientId = entity.clientId
          ..entitys.addAll(entitys
              .where((entity) => !(entity as Record).isPaid)
              .map((entity) => PaymentableEntity.fromModel(entity))
              .toList())),
        filterEntity: state.clientState.map[entity.clientId],
      );

       */
      break;
    case EntityAction.download:
      //launch(entity.invitationDownloadLink);
      break;
    case EntityAction.bulkDownload:
      store.dispatch(DownloadModelsRequest(
          snackBarCompleter<Null>(context, localization.exportedData),
          entityIds));
      break;
    case EntityAction.restore:
      final message = entityIds.length > 1
          ? localization.restoredDocuments
          .replaceFirst(':value', entityIds.length.toString())
          : localization.restoredDocument;
      store.dispatch(RestoreModelsRequest(
          snackBarCompleter<Null>(context, message), entityIds));
      break;
    case EntityAction.archive:
      final message = entityIds.length > 1
          ? localization.archivedDocuments
          .replaceFirst(':value', entityIds.length.toString())
          : localization.archivedDocument;
      store.dispatch(ArchiveModelsRequest(
          snackBarCompleter<Null>(context, message), entityIds));
      break;
    case EntityAction.delete:
      final message = entityIds.length > 1
          ? localization.deletedDocuments
          .replaceFirst(':value', entityIds.length.toString())
          : localization.deletedDocument;
      store.dispatch(DeleteModelsRequest(
          snackBarCompleter<Null>(context, message), entityIds));
      break;
    case EntityAction.toggleMultiselect:
      /*
      if (!store.state.entityListState.isInMultiselect()) {
        store.dispatch(StartModelMultiselect());
      }
      for (final entity in entitys) {
        if (!store.state.entityListState.isSelected(entity.id)) {
          store.dispatch(AddToModelMultiselect(entity: entity));
        } else {
          store.dispatch(RemoveFromModelMultiselect(entity: entity));
        }
      }

       */
      break;
    case EntityAction.printPdf:
    /*
      final invitation = entity.invitations.first;
      final url = invitation.downloadLink;
      final http.Response response =
          await WebClient().get(url, '', rawResponse: true);
      await Printing.layoutPdf(onLayout: (_) => response.bodyBytes);
      */
      break;
    case EntityAction.more:
      /*
      showEntityActionsDialog(
        entities: [entity],
      );

       */
      break;
  }
}
