part of 'user_cubit.dart';

// class UserState extends Equatable {
//   final User? user;

//   const UserState({
//     this.user,
//   });

//   UserState copyWith({User? user}) {
//     return UserState(
//       user: user ?? this.user,
//     );
//   }

//   @override
//   List<Object?> get props => [user];
// }

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserFailure extends UserState {
  final String errorMessage;

  UserFailure(this.errorMessage);
}
