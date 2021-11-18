import 'dart:async';

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
  try {
    emit(state.copyWith(changeProfileImageProcess: Process.loading()));

    // Delete the old profile picture so we only save 1 per user at a time
    final existing = await repository.getReferencesInFolder(event.folderId);
    await Future.wait(existing.map((ref) => repository.delete(ref.fullPath)));

    final task = await repository.upload(event.folderId, event.file);
    final url = await repository.getDownloadUrlFromFullPath(task.fullPath);

    final urls = Map<String, String>.from(state.profileImageURLs);
    urls[event.id] = url;

    emit(state.copyWith(
      changeProfileImageProcess: Process.success(),
      profileImageURLs: urls,
    ));
  } catch (e, s) {
    emit(state.copyWith(createUserProcess: Process.failed("$e\n$s")));
  }
}
