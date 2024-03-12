import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final String name;

  CommentItem(this.name);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            
            backgroundImage: NetworkImage(
                "https://cdn.shortpixel.ai/spai/w_1082+q_lossless+ret_img+to_webp/https://pawleaks.com/wp-content/uploads/2020/03/Maltese-Lifespan-Facts-You-Should-Know-scaled.jpg"),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.teal[400], fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text("1h ago", style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
                Material(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
