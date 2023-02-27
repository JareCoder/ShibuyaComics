import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shibuya_blog_app/services/crud.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({super.key});

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  late String authorName, title, desc, tags;

  static const List<String> tagList = <String>['Art', 'Comics', 'Travel'];

  String dropdownValue = tagList.first;

  final ImagePicker _imgPicker = ImagePicker();

  // ignore: avoid_init_to_null
  late XFile? selectedImg = null;

  bool _isLoading = false;

  CrudMethods crudMethods = CrudMethods();

  Future getImage() async {
    //final XFile? img = await _imgPicker.pickImage(source: ImageSource.gallery);
    final List<XFile> imgList = await _imgPicker.pickMultiImage();
    setState(() {
      //selectedImg = img;
      selectedImg = imgList.first;
    });
  }

  //Future getMultipleImages() async {
  //  final List<XFile> imgList = await _imgPicker.pickMultiImage();
  //}

  uploadBlog() async {
    //If img is not null, upload it with a random name under blogImages in db
    if (selectedImg != null) {
      setState(() {
        _isLoading = true;
      });

      Reference dbRef = FirebaseStorage.instance.ref();
      Reference imgRef =
          dbRef.child('blogImages').child('${randomAlphaNumeric(9)}.jpg');

      try {
        final UploadTask uploadTask = imgRef.putFile(File(selectedImg!.path));

        // ignore: todo
        //TODO: Make uploadTast event listener to Switch case and include progress% screen
        uploadTask.snapshotEvents.listen((snapshot) async {
          if (snapshot.state == TaskState.success) {
            var downloadUrl = await imgRef.getDownloadURL();
            //setState(() {
            //  _isLoading = false;
            //});
            Map<String, String> blogMap = {
              'imgUrl': downloadUrl,
              'authorName': authorName,
              'title': title,
              'description': desc,
              'tags': tags
            };

            crudMethods.addData(blogMap).then((result) {
              Navigator.pop(context);
            });
          }
        });
      } on FirebaseException catch (e) {
        return e;
      }
    } else {
      // ignore: todo
      //TODO: Upload stuff that shows temp image (local file or url?)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.file_upload),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: getImage,
                  child: selectedImg != null
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(File(selectedImg!.path),
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: const Icon(Icons.add_a_photo,
                              color: Colors.black54),
                        ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration:
                            const InputDecoration(hintText: 'Author Name'),
                        onChanged: (val) {
                          authorName = val;
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(hintText: 'Title'),
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                      TextField(
                        decoration:
                            const InputDecoration(hintText: 'Description'),
                        onChanged: (val) {
                          desc = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              style: TextStyle(fontSize: 20),
                              'Tag',
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8.0),
                              padding: const EdgeInsets.only(left: 6.0),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.fromBorderSide(BorderSide(
                                    color: Colors.grey, width: 0.75)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  alignment: AlignmentDirectional.bottomStart,
                                  value: dropdownValue,
                                  items: tagList.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
