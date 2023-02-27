import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shibuya_blog_app/services/crud.dart';
import 'package:shibuya_blog_app/views/create_blog.dart';
import 'package:shibuya_blog_app/widgets/blogs_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = CrudMethods();

  late Stream<QuerySnapshot<Map<String, dynamic>>> blogsStream;

  late String blogs;

  @override
  initState() {
    super.initState();
    blogs = 'blogs';

    blogsStream = crudMethods.getData(blogs);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Shibuya',
                style: TextStyle(fontSize: 22, color: Colors.purple),
              ),
              Text(
                'Blog',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          bottom: const TabBar(
            indicator: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.purple,
            ),
            tabs: [
              Tab(
                icon: Icon(Icons.access_time_outlined),
              ),
              Tab(
                icon: Icon(Icons.brush),
              ),
              Tab(
                icon: Icon(Icons.chrome_reader_mode_outlined),
              ),
              Tab(
                icon: Icon(Icons.flight_outlined),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: blogsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //print("Snapshost has data!");
              final docs = snapshot.data!.docs;

              return TabBarView(
                children: [
                  BlogsList(
                    docsList: docs,
                    showTags: true,
                  ),
                  BlogsList(
                    docsList:
                        docs.where((d) => d.get('tags') == 'Art').toList(),
                  ),
                  BlogsList(
                    docsList:
                        docs.where((d) => d.get('tags') == 'Comics').toList(),
                  ),
                  BlogsList(
                    docsList:
                        docs.where((d) => d.get('tags') == 'Travel').toList(),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              const Text('Error recieving data!');
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateBlog(),
                    ),
                  ),
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
