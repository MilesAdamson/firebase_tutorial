import 'dart:async';
import 'dart:io';

import 'package:firebase_tutorial/blocs/process.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/repositories/fire_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> changeProfileImage(
  UsersChangeProfileImageEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  FileRepository repository,
) async {
  final existingImage = state.userProfileImages[event.id];
  final files = Map<String, File>.from(state.userProfileImages);
  files[event.id] = event.file;
  emit(state.copyWith(userProfileImages: files));

  try {
    var processes = Map<String, Process>.from(state.userProfileImageProcesses);
    processes[event.id] = Process.loading();
    emit(state.copyWith(userProfileImageProcesses: processes));

    await repository.upload(event.folderId, event.file);
    processes = Map<String, Process>.from(state.userProfileImageProcesses);
    processes[event.id] = Process.success();

    final files = Map<String, File>.from(state.userProfileImages);
    files[event.id] = event.file;
    emit(state.copyWith(
      userProfileImageProcesses: processes,
      userProfileImages: files,
    ));
  } catch (e, s) {
    final processes =
        Map<String, Process>.from(state.userProfileImageProcesses);
    processes[event.id] = Process.failed("$e\n$s");
    final files = Map<String, File>.from(state.userProfileImages);

    if (existingImage != null) {
      files[event.id] = existingImage;
    } else {
      files.remove(event.id);
    }

    emit(state.copyWith(
      userProfileImageProcesses: processes,
      userProfileImages: files,
    ));
  }
}
