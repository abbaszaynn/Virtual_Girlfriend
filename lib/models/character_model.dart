class Character {
  final String id;
  final String name;
  final String age;
  final String imagePath;
  final String vibe;
  final List<String> categories; // Support multiple categories for filtering
  final String description;
  final String systemPrompt;
  final String voiceId;
  final String imagePromptDescription;
  final String? gender; // Gender field: Male, Female, Non-binary

  const Character({
    required this.id,
    required this.name,
    required this.age,
    required this.imagePath,
    required this.vibe,
    required this.categories,
    required this.description,
    required this.systemPrompt,
    required this.voiceId,
    required this.imagePromptDescription,
    this.gender, // Optional for backward compatibility
  });
}
