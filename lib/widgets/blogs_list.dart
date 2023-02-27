import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// {@template blogs_list}
/// List of BlogTiles
/// {@endtemplate}
class BlogsList extends StatelessWidget {
  ///{@macro blogs_list}
  const BlogsList({
    super.key,
    required this.docsList,
    this.showTags = false,
  });

  ///List of documents to show in ListView
  final List<DocumentSnapshot> docsList;

  ///showTags in BlogTile
  final bool showTags;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: docsList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final data = docsList[index].data()! as Map<String, dynamic>;

        return _BlogsTile(
          imgUrl: data['imgUrl'] as String,
          title: data['title'] as String,
          description: data['description'] as String,
          authorName: data['authorName'] as String,
          tags: data['tags'] as String,
          showTags: showTags,
        );
      },
      separatorBuilder: (context, count) => const Divider(),
    );
  }
}

class _BlogsTile extends StatelessWidget {
  const _BlogsTile({
    required this.imgUrl,
    required this.title,
    required this.description,
    required this.authorName,
    required this.tags,
    required this.showTags,
  });

  final String imgUrl, title, description, authorName, tags;

  final bool showTags;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    //Show tags on top right corner

    return SizedBox(
      //Blog box
      height: 180,
      child: Stack(
        children: [
          //BG img
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: screenWidth,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            //Darken img layer
            height: 180,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6)),
            //Tag box & text
            child: showTags == true
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6, top: 6),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black45.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.black45,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          tags,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
          //Content box (txt)
          SizedBox(
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  authorName,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
