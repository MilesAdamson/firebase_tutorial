import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class Process<T> {
  final bool isLoading;
  final String? errorMessage;
  final bool succeeded;
  final T? result;

  const Process(
    this.isLoading,
    this.errorMessage,
    this.succeeded, {
    this.result,
  });

  factory Process.loading() {
    return const Process(
      true,
      null,
      false,
    );
  }

  factory Process.failed(String errorMessage) {
    return Process(
      false,
      errorMessage,
      false,
    );
  }

  factory Process.success({T? result}) {
    return Process<T>(
      false,
      null,
      true,
      result: result,
    );
  }

  factory Process.initial() {
    return const Process(
      false,
      null,
      false,
    );
  }

  @override
  int get hashCode => hashValues(
        isLoading,
        errorMessage,
        succeeded,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Process &&
            errorMessage == other.errorMessage &&
            isLoading == other.isLoading &&
            succeeded == other.succeeded);
  }
}
