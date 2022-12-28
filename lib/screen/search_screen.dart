import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitsta/screen/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  // @override
  // void dispose() {
  //   // TODO: implement dispose

  //   searchController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.search), labelText: 'Search for a user'),
                onFieldSubmitted: (String _) {
                  setState(() {
                    isShowUsers = true;
                  });
                }),
          ),
        ),
        isShowUsers
            ? Expanded(
                flex: 9,
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('username',
                          isGreaterThanOrEqualTo: searchController.text)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  uid: (snapshot.data! as dynamic).docs[index]
                                      ['uid']),
                            )),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['profImage']),
                              ),
                              title: Text((snapshot.data! as dynamic)
                                  .docs[index]['username']),
                            ),
                          );
                        });
                  },
                ),
              )
            : Expanded(
                flex: 9,
                child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl']),
                      staggeredTileBuilder: (index) => StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    );
                  },
                ),
              )
      ],
    ));
  }
}
