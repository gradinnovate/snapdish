class Ingredient {
  final String id;
  final String name;
  // Add other relevant fields if necessary e.g., quantity, unit

  Ingredient({required this.id, required this.name});

  // Optional: For easier comparison and removal if objects are recreated
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
