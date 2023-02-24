part of 'follow_cubit.dart';

abstract class FollowState {}

class FollowInitial extends FollowState {}

class FollowLoading extends FollowState {}

class FollowLoaded extends FollowState {
  final List<Following> followings;
  final List<Follower> followers;

  FollowLoaded(this.followings, this.followers);
}

class FollowFailure extends FollowState {
  final String errorMessage;

  FollowFailure(this.errorMessage);
}
