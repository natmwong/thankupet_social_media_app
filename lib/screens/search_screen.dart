import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:thankupet_social_media_app/screens/profile_screen.dart";
import "package:thankupet_social_media_app/utils/theme_colors.dart";

// Search screen which allows users to view all post images in a grid view
// and search user profiles
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: TextFormField(
          cursorColor: primaryColor,
          style: TextStyle(color: primaryColor),
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
            labelStyle: TextStyle(color: secondaryColor),
            border: InputBorder.none,
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: isShowUsers
          ? FutureBuilder(
              //query all profiles greater than or equal to search excluding current user
              future: Supabase.instance.client
                  .from('profiles')
                  .select('*')
                  .gte('username', searchController.text)
                  .neq('id', Supabase.instance.client.auth.currentUser!.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                    ),
                  );
                }

                //build profile list of related users
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic)[index]['id'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic)[index]['avatar_url']),
                        ),
                        title: Text(
                          (snapshot.data! as dynamic)[index]['username'],
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          //build gridview of current post images
          : FutureBuilder(
              future: Supabase.instance.client.from('posts').select('*'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                    ),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic)[index]['image_url'],
                  ),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0) ? 2 : 1,
                    (index % 7 == 0) ? 2 : 1,
                  ),
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                );
              },
            ),
    );
  }
}
