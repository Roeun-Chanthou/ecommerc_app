import 'package:flutter/material.dart';

class ContactNumberModalDailog {
  ContactNumberModalDailog._();

  static Future show(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const ContactOptionModal(),
        );
      },
    );
  }
}

class ContactOptionModal extends StatefulWidget {
  const ContactOptionModal({
    super.key,
  });

  @override
  State<ContactOptionModal> createState() => _ContactOptionModalState();
}

class _ContactOptionModalState extends State<ContactOptionModal> {
  var txtNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {});
              Navigator.pop(
                context,
                txtNumber.text,
              );
            },
            child: Container(
              height: 24,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text('Contact Number'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: TextField(
              autofocus: true,
              controller: txtNumber,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 50),
              ),
              onPressed: () {
                setState(() {});
                Navigator.pop(
                  context,
                  txtNumber.text,
                );
              },
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
