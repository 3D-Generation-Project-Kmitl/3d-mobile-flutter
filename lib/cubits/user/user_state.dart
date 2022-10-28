part of 'user_cubit.dart';

class UserState extends Equatable {
  final User? user;

  const UserState({
    this.user,
  });

  UserState copyWith({User? user}) {
    return UserState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];
}

class UserLoadingState extends UserState {}

class UserFailureState extends UserState {
  final String errorMessage;

  const UserFailureState(this.errorMessage);
}

class UserSuccessState extends UserState {}
