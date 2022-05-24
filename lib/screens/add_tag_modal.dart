import 'package:flutter/material.dart';
import 'baits.dart';

class AddTagModal extends StatelessWidget {
  final Function addTagCb;
  AddTagModal(this.addTagCb);

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.only(left: 10),
//       child: TextField(
//         autofocus: true,
//         decoration: InputDecoration(
//             border: InputBorder.none, hintText: '\t\tSubmit a tag here'),
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    String newTagTitle;
    TextEditingController newTagTitle_C = TextEditingController();

    @override
    void dispose() {
      newTagTitle_C.dispose();
    }

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.only(top: 20.0, left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Add Tag',
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            TextField(
              controller: newTagTitle_C,
              autofocus: true,
              textAlign: TextAlign.center,
              // onChanged: (newValue) {
              //   // newTagTitle = newValue;
              //   newTagTitle_C.value = newValue;
              // },
            ),
            const SizedBox(
              height: 15.0,
            ),
            FlatButton(
              onPressed: () {
                addTagCb(newTagTitle_C.text);
              },
              child: Text('Add'),
              color: Colors.lightBlue,
              textColor: Colors.white,
            )
          ],
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
