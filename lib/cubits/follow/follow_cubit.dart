import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit() : super(FollowInitial());

  final followRepository = FollowRepository();

  Future<void> getFollow() async {
    try {
      emit(FollowLoading());
      final followings = await followRepository.getFollowing();
      final followers = await followRepository.getFollower();
      emit(FollowLoaded(followings, followers));
    } on String catch (e) {
      emit(FollowFailure(e));
    }
  }

  Future<void> follow({required int userId}) async {
    try {
      if (state is FollowLoaded) {
        final followings = (state as FollowLoaded).followings;
        final followers = (state as FollowLoaded).followers;
        final following = await followRepository.follow(userId: userId);
        followings.insert(0, following);
        emit(FollowLoaded(followings, followers));
      }
    } on String catch (e) {
      emit(FollowFailure(e));
    }
  }

  Future<void> unFollow({required int userId}) async {
    try {
      if (state is FollowLoaded) {
        final followings = (state as FollowLoaded).followings;
        final followers = (state as FollowLoaded).followers;
        await followRepository.unFollow(userId: userId);
        followings.removeWhere((element) => element.followedId == userId);
        emit(FollowLoaded(followings, followers));
      }
    } on String catch (e) {
      emit(FollowFailure(e));
    }
  }

  bool isFollowing(int userId) {
    if (state is FollowLoaded) {
      final followings = (state as FollowLoaded).followings;
      return followings.any((element) => element.followedId == userId);
    }
    return false;
  }

  void clear() {
    emit(FollowInitial());
  }
}
