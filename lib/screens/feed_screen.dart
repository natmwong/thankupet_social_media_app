import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:thankupet_social_media_app/utils/theme_colors.dart";
import "package:thankupet_social_media_app/widgets/logo_text.dart";
import "package:thankupet_social_media_app/widgets/post_card.dart";

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: false,
        title: LogoText(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.messenger_outline,
              color: secondaryColor,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream:
            Supabase.instance.client.from('posts').stream(primaryKey: ['id']),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) => PostCard(
              snap: posts[index],
            ),
          );
        },
      ),
    );
  }
}
