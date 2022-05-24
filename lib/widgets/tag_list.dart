import 'package:catchi/models/tag_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catchi/models/tag_data.dart';
import 'package:catchi/models/tag.dart';

class TagList extends StatelessWidget {
  const TagList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TagData>(
      builder: (context, tagData, child) {
              final tagList = tagData.tagList;
              return Padding(
                padding: const EdgeInsets.only(top: 3, right: 50.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 3.0,
                  children: <Widget>[
                    for (var e in tagList)
                    /* Maybe TODO: better way to loop this...
                    *   https://stackoverflow.com/questions/71426566/iterate-through-a-list-in-the-widget-tree-with-an-index
                    */
                      Chip(
                        label: Text(e.title),
                        onDeleted: (){
                          tagData.deleteTag(e);
                        },
                      )
                  ],
                ),
              );
      },
    );
  }
}
