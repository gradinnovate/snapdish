import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipeStyleTimeSelectionView extends StatefulWidget {
  // final List<String> ingredients; // Will be passed in later
  // RecipeStyleTimeSelectionView({Key? key, required this.ingredients}) : super(key: key);

  @override
  _RecipeStyleTimeSelectionViewState createState() => _RecipeStyleTimeSelectionViewState();
}

class _RecipeStyleTimeSelectionViewState extends State<RecipeStyleTimeSelectionView> {
  String? _selectedStyle;
  String? _selectedTime;

  // Mock data
  final List<String> _styleOptions = ["中式", "日式", "西式", "韓式", "新奇"];
  final List<String> _timeOptions = ["10 分鐘", "20 分鐘", "30 分鐘"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Style & Time"),
        leading: IconButton( // Explicit back button for clarity
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Style Selection
            Text(
              "Choose a Cooking Style:",
              style: Theme.of(context).textTheme.titleLarge, // headline6 is deprecated
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _styleOptions.map((style) => ChoiceChip(
                label: Text(style),
                selected: _selectedStyle == style,
                onSelected: (selected) {
                  setState(() {
                    _selectedStyle = selected ? style : null;
                  });
                },
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: _selectedStyle == style ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                ),
              )).toList(),
            ),
            SizedBox(height: 30),

            // Time Selection
            Text(
              "Select Cooking Time:",
              style: Theme.of(context).textTheme.titleLarge, // headline6 is deprecated
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _timeOptions.map((time) => ElevatedButton(
                child: Text(time),
                onPressed: () {
                  setState(() {
                    _selectedTime = time;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedTime == time ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                  foregroundColor: _selectedTime == time ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                  side: _selectedTime == time ? null : BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
              )).toList(),
            ),
            
            Spacer(), // Pushes button to the bottom

            ElevatedButton(
              child: Text("Generate Recipe"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0)
              ),
              onPressed: (_selectedStyle != null && _selectedTime != null) ? () {
                // Navigate to the final dish image view
                context.push('/final-dish-image');
              } : null, // Button disabled if not all selections are made
            ),
          ],
        ),
      ),
    );
  }
}
