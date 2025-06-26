// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SummaryStore on _SummaryStore, Store {
  late final _$summaryAtom =
      Atom(name: '_SummaryStore.summary', context: context);

  @override
  String? get summary {
    _$summaryAtom.reportRead();
    return super.summary;
  }

  @override
  set summary(String? value) {
    _$summaryAtom.reportWrite(value, super.summary, () {
      super.summary = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_SummaryStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$summarizeDocumentAsyncAction =
      AsyncAction('_SummaryStore.summarizeDocument', context: context);

  @override
  Future<void> summarizeDocument(XFile document) {
    return _$summarizeDocumentAsyncAction
        .run(() => super.summarizeDocument(document));
  }

  @override
  String toString() {
    return '''
summary: ${summary},
errorMessage: ${errorMessage}
    ''';
  }
}
