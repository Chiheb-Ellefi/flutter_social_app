import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/comment_model.dart';
import 'package:my_project/main.dart';

// ignore: must_be_immutable
class Comment extends StatefulWidget {
  Comment(
      {super.key,
      required this.author,
      required this.text,
      required this.date,
      required this.likes,
      required this.replies,
      required this.isCommentListVisible,
      required this.uid});
  String author;
  String text;
  int date;
  List<dynamic>? likes;
  List<dynamic> replies;
  bool isCommentListVisible;
  String uid;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  updateLike() async {
    final queryTopic = FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('uid', isEqualTo: widget.uid)
        .get();

    final value = await queryTopic;
    final commentsList = <CommentModel>[];

    for (final element in value.docs) {
      final QuerySnapshot snapshot = await element.reference
          .collection(widget.uid + 'comments')
          .where('date', isEqualTo: widget.date)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final comments = snapshot.docs.forEach((element) {
          element.reference.update({
            'likes': likes,
          });
        });
      }
    }
  }

  final reply = TextEditingController();
  CommentModel? myReply;
  CommentModel getReply() {
    CommentModel myReply = CommentModel(
      author: widget.author,
      text: reply.text.trim(),
      likes: [],
      date: DateTime.now(),
      replies: [],
    );
    return myReply;
  }

  updateReplies() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final queryTopic = FirebaseFirestore.instance
          .collection(topicsCollection)
          .where('uid', isEqualTo: widget.uid)
          .get();

      final value = await queryTopic;
      final commentsList = <CommentModel>[];
      List<dynamic> replies = widget.replies;
      replies.add(myReply!.toMap());
      for (final element in value.docs) {
        final QuerySnapshot snapshot = await element.reference
            .collection(widget.uid + 'comments')
            .where('date', isEqualTo: widget.date)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final comments = snapshot.docs.forEach((element) {
            element.reference.update({
              'replies': replies,
            }).then((_) {
              reply.clear(); // Clear the text editing controller
              setState(() {}); // Rebuild the widget
            });
          });
        }
      }
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  List<dynamic>? likes;
  bool isLiked = false;
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  Icon? myIcon;
  List<dynamic>? myComments;
  List<dynamic>? myReplies;
  String len = '';

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.date);
    isLiked = widget.likes!.contains(userUid);
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0, // Set the desired border width
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outlined, size: 30),
                        Text(widget.author,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                    Text('${date.day}/${date.month}/${date.year}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.trashCan),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Delete')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            widget.text,
            style: const TextStyle(
              color: Color.fromRGBO(16, 22, 35, .600),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (isLiked) {
                          likes = widget.likes;
                          widget.likes!.remove(userUid);
                          likes = widget.likes;
                          isLiked = !isLiked;
                        } else {
                          likes = widget.likes;
                          widget.likes!.add(userUid);
                          likes = widget.likes;
                          isLiked = !isLiked;
                        }
                      });
                      updateLike();
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite_rounded : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                      size: 28,
                    ),
                  ),
                  Text(widget.likes!.length.toString(),
                      style: const TextStyle(fontSize: 17)),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isCommentListVisible =
                            !widget.isCommentListVisible;
                      });
                    },
                    icon: Icon(
                        widget.isCommentListVisible
                            ? FontAwesomeIcons.solidMessage
                            : FontAwesomeIcons.message,
                        color: Colors.black87),
                  ),
                  Text(
                    widget.replies.length.toString(),
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
          if (widget.isCommentListVisible)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextField(
                    controller: reply,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            myReply = getReply();
                            updateReplies();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.reply,
                            color: Colors.black87,
                          ),
                        ),
                        hintText: 'Reply to this comment '),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.replies.length,
                  itemBuilder: (context, index) {
                    final comment = widget.replies[index];
                    return Comment(
                      uid: widget.uid,
                      text: comment['text'],
                      author: comment['author'],
                      date: comment['date'],
                      likes: comment['likes'],
                      replies: comment['replies'],
                      isCommentListVisible: false,
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
