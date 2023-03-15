class CountUser {
  CountUser({
    this.followers = 0,
    this.following = 0,
  });

  int followers;
  int following;

  factory CountUser.fromJson(Map<String, dynamic> json) => CountUser(
        followers: json["Followers"] ?? 0,
        following: json["Following"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Followers": followers,
        "Following": following,
      };
}
