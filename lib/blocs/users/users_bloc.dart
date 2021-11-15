import 'package:firebase_tutorial/blocs/users/event_handlers/create_user.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/delete_user.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/load_all_users.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/on_user_updated.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/query_users.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/subscribe_to_user.dart';
import 'package:firebase_tutorial/blocs/users/event_handlers/unsubscribe_to_user.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final Repository<UserModel> repository;

  UsersBloc(this.repository) : super(UsersState.initial()) {
    on<UsersLoadAllEvent>(
      (event, emit) => loadAllUsers(event, state, emit, repository),
    );

    on<UsersCreateEvent>(
      (event, emit) => createUser(event, state, emit, repository),
    );

    on<UsersQueryEvent>(
      (event, emit) => queryUsers(event, state, emit, repository),
    );

    on<UsersDeleteEvent>(
      (event, emit) => deleteUser(event, state, emit, repository),
    );

    on<UsersSubscribeEvent>(
      (event, emit) => subscribeToUser(event, state, emit, repository, this),
    );

    on<UsersUnsubscribeEvent>(
      (event, emit) => unsubscribeToUser(event, state, emit, repository),
    );

    on<UsersUpdatedEvent>(
      (event, emit) => onUserUpdated(event, state, emit, repository),
    );
  }
}
