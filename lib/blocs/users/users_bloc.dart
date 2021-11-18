import 'package:firebase_tutorial/blocs/users/event_handlers/change_profile_image.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/create_user.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/delete_user.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/load_all_users.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/load_profile_image.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/on_user_updated.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/query_users.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/subscribe_to_user.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/unsubscribe_to_user.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/repositories/fire_repository.dart';
import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository _userRepository;
  final FileRepository _fileRepository;

  UsersBloc(
    this._userRepository,
    this._fileRepository,
  ) : super(UsersState.initial()) {
    on<UsersLoadAllEvent>(
      (event, emit) => loadAllUsers(event, state, emit, _userRepository),
    );

    on<UsersCreateEvent>(
      (event, emit) => createUser(event, state, emit, _userRepository),
    );

    on<UsersQueryEvent>(
      (event, emit) => queryUsers(event, state, emit, _userRepository),
    );

    on<UsersDeleteEvent>(
      (event, emit) => deleteUser(event, state, emit, _userRepository),
    );

    on<UsersSubscribeEvent>(
      (event, emit) => subscribeToUser(event, state, emit, this),
    );

    on<UsersUnsubscribeEvent>(
      (event, emit) => unsubscribeToUser(event, state, emit),
    );

    on<UsersUpdatedEvent>(
      (event, emit) => onUserUpdated(event, state, emit),
    );

    on<UsersChangeProfileImageEvent>(
      (event, emit) => changeProfileImage(event, state, emit, _fileRepository),
    );

    on<UsersLoadProfileImageEvent>(
      (event, emit) => loadProfileImage(event, state, emit, _fileRepository),
    );
  }
}
