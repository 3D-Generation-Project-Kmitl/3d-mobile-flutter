class CountUser {
  CountUser({
    this.follower = 0,
    this.following = 0,
  });

  int follower;
  int following;

  factory CountUser.fromJson(Map<String, dynamic> json) => CountUser(
        follower: json["Follower"] ?? 0,
        following: json["Following"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Follower": follower,
        "Following": following,
      };
}
