import 'package:flutter/material.dart';

class FinishedDishView extends StatelessWidget {
  final String imageUrl;

  const FinishedDishView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Dish'), // As per UX_Snapdish.md Section 3.1 成品圖展示頁面
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: imageHeight,
            width: double.infinity, // Take full width
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover, // Cover the container bounds
              // Placeholder image while loading or if URL is invalid
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.error, color: Colors.red, size: 50),
                      Text('Error loading image'),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: const Icon(Icons.restaurant_menu), // Placeholder icon
                  label: const Text('Return to Recipe'),
                  onPressed: () {
                    // For now, just print a message or pop
                    print('Return to Recipe button pressed');
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share), // Placeholder icon
                  label: const Text('Save/Share Image'),
                  onPressed: () {
                    // For now, just print a message
                    print('Save/Share Image button pressed');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
