import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thankupet_social_media_app/resources/auth_methods.dart';
import 'package:thankupet_social_media_app/resources/storage_methods.dart';
import 'package:thankupet_social_media_app/screens/login_screen.dart';
import 'package:thankupet_social_media_app/screens/update_profile_screen.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';
import 'package:thankupet_social_media_app/utils/utils.dart';
import 'package:thankupet_social_media_app/widgets/follow_button.dart';

// Profile screen for current user and all other users
class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  String current_uid = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    getData();
    print("current user in profile screen: " + widget.uid);
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await Supabase.instance.client
          .from('profiles')
          .select('*')
          .eq('id', widget.uid)
          .single();

      // Get post length
      var postSnap = await Supabase.instance.client
          .from('posts')
          .select('*')
          .eq('user_id', widget.uid);

      postLen = postSnap.length;
      userData = userSnap;
      followers = userSnap['followers'].length;
      following = userSnap['following'].length;
      isFollowing = userSnap['followers'].contains(current_uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      userData['username'],
                      style: TextStyle(color: primaryColor),
                    ),
                    Spacer(),
                    Supabase.instance.client.auth.currentUser!.id == widget.uid
                        ? IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              // Add settings functionality here
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              // Add functionality for three dot icon here
                            },
                          ),
                  ],
                ),
              ),
              centerTitle: false,
              automaticallyImplyLeading:
                  Supabase.instance.client.auth.currentUser!.id != widget.uid,
              leading:
                  Supabase.instance.client.auth.currentUser!.id != widget.uid
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      : null,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(userData['avatar_url']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Supabase.instance.client.auth.currentUser!
                                                .id ==
                                            widget.uid
                                        ? Column(
                                            children: [
                                              FollowButton(
                                                text: 'Edit Profile',
                                                backgroundColor: accentColor,
                                                textColor: primaryColor,
                                                borderColor: accentColor,
                                                function: () async {
                                                  await Navigator.of(context)
                                                      .push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateProfileScreen(
                                                        isRegistration: false,
                                                      ),
                                                    ),
                                                  );
                                                  // Refresh profile data after update
                                                  getData();
                                                },
                                              ),
                                              FollowButton(
                                                text: 'Sign out',
                                                backgroundColor:
                                                    backgroundColor,
                                                textColor: primaryColor,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await AuthMethods().signOut();
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: primaryColor,
                                                textColor: Colors.black,
                                                borderColor: secondaryColor,
                                                function: () async {
                                                  await StorageMethods()
                                                      .followUser(
                                                          Supabase
                                                              .instance
                                                              .client
                                                              .auth
                                                              .currentUser!
                                                              .id,
                                                          userData['id']);

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: accentColor,
                                                textColor: primaryColor,
                                                borderColor: accentColor,
                                                function: () async {
                                                  await StorageMethods()
                                                      .followUser(
                                                          Supabase
                                                              .instance
                                                              .client
                                                              .auth
                                                              .currentUser!
                                                              .id,
                                                          userData['id']);

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['full_name'],
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              userData['pronouns'],
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: Supabase.instance.client
                      .from('posts')
                      .select('*')
                      .eq('user_id', widget.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: secondaryColor,
                        ),
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final snap = (snapshot.data! as dynamic)[index];

                          return Container(
                            child: Image(
                              image: NetworkImage(snap['image_url']),
                              fit: BoxFit.cover,
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            num.toString(),
            style: const TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: primaryColor,
              ),
            ),
          ),
        ]);
  }
}
