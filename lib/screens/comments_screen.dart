import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:thankupet_social_media_app/models/user.dart" as model;
import "package:thankupet_social_media_app/providers/user_provider.dart";
import "package:thankupet_social_media_app/resources/storage_methods.dart";
import "package:thankupet_social_media_app/utils/theme_colors.dart";
import "package:thankupet_social_media_app/utils/utils.dart";
import "package:thankupet_social_media_app/widgets/comment_card.dart";

// Comments screen of the selected post, allowing user to post a comment and like comments
class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text(
            'Comments',
            style: TextStyle(color: primaryColor),
          ),
          centerTitle: false,
          iconTheme: IconThemeData(color: primaryColor),
        ),
        body: StreamBuilder(
            stream: Supabase.instance.client
                .from('comments')
                .stream(primaryKey: ['id'])
                .eq('post_id', widget.snap['id'])
                .order('created_at',
                    ascending:
                        false), // query all comments of the post in descending order based on date_published
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                );
              }

              final comments = snapshot.data!;

              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) => CommentCard(
                  snap: comments[index],
                ),
              );
            }),
        bottomNavigationBar: SafeArea(
            child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.avatarUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: TextField(
                    style: TextStyle(color: primaryColor),
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      hintStyle: TextStyle(color: secondaryColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                  onTap: () async {
                    String res = await StorageMethods().postComment(
                      widget.snap['id'], // post id
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.avatarUrl,
                    );
                    if (res == "success") {
                      showSnackBar("Comment success", context);
                    }
                    setState(() {
                      _commentController.text = "";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: accentColor,
                      ),
                    ),
                  ))
            ],
          ),
        )));
  }
}
