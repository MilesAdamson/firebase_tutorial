import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/repositories/fire_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> loadProfileImage(
  UsersLoadProfileImageEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  FileRepository repository,
) async {
  try {
    final refs = await repository.getReferencesInFolder(event.folderId);

    // As a design choice, this folder should only have 1 file which is the profile image
    final ref = refs.firstOrNull;

    if (ref != null) {
      final url = await ref.getDownloadURL();
      final urls = Map<String, String>.from(state.profileImageURLs);
      urls[event.id] = url;
      emit(state.copyWith(profileImageURLs: urls));
    }
  } catch (e, s) {
    // Failures to load profile images fail silently as they just
    // see the default empty state image and its low consequence
    debugPrint("$e\n$s");
  }
}
