import 'package:flutter/material.dart';

class IconSelectionModal extends StatefulWidget {
  const IconSelectionModal({Key? key}) : super(key: key);

  @override
  _IconSelectionModalState createState() => _IconSelectionModalState();
}

class _IconSelectionModalState extends State<IconSelectionModal> {
  final TextEditingController _textController = TextEditingController();
  IconData? _selectedIcon;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter text',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIcon = Icons.favorite;
                    });
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: _selectedIcon == Icons.favorite
                        ? Colors.blue
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIcon = Icons.star;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: _selectedIcon == Icons.star
                        ? Colors.blue
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIcon = Icons.person;
                    });
                  },
                  icon: Icon(
                    Icons.person,
                    color: _selectedIcon == Icons.person
                        ? Colors.blue
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Do something with the entered text and selected icon
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
