import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thankupet_social_media_app/models/user.dart';
import 'package:thankupet_social_media_app/providers/user_provider.dart';
import 'package:thankupet_social_media_app/screens/nav_bar.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';
import 'package:thankupet_social_media_app/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  get backgroundColor => null;

  @override
  void initState() {
    super.initState();
    //getComments();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    // Extract values from widget.snap and handle null cases
    final String profImage = widget.snap['profimg_url'];
    final String username = widget.snap['username'];
    final String imageUrl = widget.snap['image_url'];
    final String description = widget.snap['description'];
    final List<dynamic> likes = widget.snap['likes'];
    final DateTime datePublished =
        widget.snap['datePublished']?.toDate() ?? DateTime.now();

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                // HEADER SECTION
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(profImage),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: primaryColor),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map(
                                  (e) => InkWell(
                                    // onTap: () async {
                                    //   FirestoreMethods().deletePost(widget.snap['postId']);
                                    //   Navigator.of(context).pop();
                                    // },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          // IMAGE SECTION
          GestureDetector(
            onDoubleTap: () async {
              // await FirestoreMethods().likePost(
              //   widget.snap['postId'],
              //   user.uid,
              //   likes,
              // );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          // LIKE COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: likes.contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NavBar(), //replace w comments
                    ),
                  ),
                  // onPressed: () async {
                  //   await FirestoreMethods().likePost(
                  //     widget.snap['postId'],
                  //     user.uid,
                  //     likes,
                  //   );
                  // },
                  icon: likes.contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: secondaryColor,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        NavBar(), //replace later with comment screen
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                  color: secondaryColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: secondaryColor,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: secondaryColor,
                  ),
                  onPressed: () {},
                ),
              ))
            ],
          ),
          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: secondaryColor,
                      ),
                  child: Text('${likes.length} likes',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: secondaryColor)),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                            text: username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: ' $description',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NavBar(), //replace w comments
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Text(
                    DateFormat.yMMMd().format(datePublished),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
