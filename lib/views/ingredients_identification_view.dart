import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/models/ingredient.dart'; // Import Ingredient model

class IngredientsIdentificationView extends StatefulWidget {
  @override
  _IngredientsIdentificationViewState createState() => _IngredientsIdentificationViewState();
}

class _IngredientsIdentificationViewState extends State<IngredientsIdentificationView> {
  bool _isLoading = false;
  List<Ingredient> _identifiedIngredients = []; // Changed to List<Ingredient>

  // Simulated API call to fetch identified ingredients
  Future<List<Ingredient>> _fetchIdentifiedIngredients(String imagePath /* conceptual */) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    // Mock data, replace with actual API call in the future
    return [
      Ingredient(id: '1', name: 'Tomatoes'),
      Ingredient(id: '2', name: 'Cheese'),
      Ingredient(id: '3', name: 'Basil'),
      Ingredient(id: '4', name: 'Mushrooms'),
    ];
  }

  void _startIdentification() async {
    setState(() {
      _isLoading = true;
      _identifiedIngredients = []; // Clear previous results
    });
    // Simulate API call using the new method
    List<Ingredient> fetchedIngredients = await _fetchIdentifiedIngredients("dummy_image_path.jpg");
    setState(() {
      _identifiedIngredients = fetchedIngredients;
      _isLoading = false;
    });
  }

  void _addIngredient(String name) {
    if (name.isNotEmpty && !_identifiedIngredients.any((ing) => ing.name == name)) {
      setState(() {
        // Create a simple unique ID for the new ingredient, e.g., using timestamp
        final newId = DateTime.now().millisecondsSinceEpoch.toString();
        _identifiedIngredients.add(Ingredient(id: newId, name: name));
      });
    }
  }

  void _removeIngredient(Ingredient ingredient) { // Changed to accept Ingredient object
    setState(() {
      _identifiedIngredients.remove(ingredient);
    });
  }

  // Placeholder for showing an add ingredient dialog
  void _showAddIngredientDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Ingredient"),
        content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(hintText: "Enter ingredient name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              _addIngredient(controller.text);
              Navigator.pop(context);
            },
            child: Text("Add")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Identify Ingredients")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Camera button - stays at the top
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text("Capture/Upload Image"),
                onPressed: _isLoading ? null : _startIdentification,
              ),
              SizedBox(height: 20),
              
              // Main content area
              Expanded(
                child: _isLoading 
                  ? Center(child: CircularProgressIndicator())
                  : _identifiedIngredients.isEmpty
                    ? Center(child: Text("Please capture or upload an image to identify ingredients."))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Identified Ingredients:", style: Theme.of(context).textTheme.titleLarge),
                          SizedBox(height: 10),
                          
                          // Make the ingredients list scrollable if it gets too large
                          Expanded(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: _identifiedIngredients.map((ingredient) => Chip(
                                  label: Text(ingredient.name),
                                  onDeleted: () => _removeIngredient(ingredient),
                                )).toList(),
                              ),
                            ),
                          ),
                          
                          // Add ingredient button
                          ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text("Add Ingredient"),
                            onPressed: _showAddIngredientDialog,
                          ),
                        ],
                      ),
              ),
              
              // Continue button always at the bottom
              SizedBox(height: 16),
              ElevatedButton(
                child: Text("Continue"),
                onPressed: _identifiedIngredients.isEmpty ? null : () {
                  context.push('/recipe-style-time-selection');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
