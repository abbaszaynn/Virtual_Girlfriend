class Assets {
  Assets._();

  static const String logo = 'images/logo.png';
  static const String welcomeImage = 'images/welcome_image.png';
  static const String fb = 'images/fb.png';
  static const String google = 'images/google.png';
  static const String apple = 'images/apple.png';
  static const String dLogo = 'images/d_logo.png';
  static const String aiIcon = 'images/ai_icon.png';
  static const String aiGroup = 'images/ai_group.png';
  static const String maya = 'images/maya.png';
  static const String elena = 'images/elena.png';
  static const String aria = 'images/aria.png';
  static const String sofia = 'images/sofia.png';

  // Female preference images (1-6)
  static const String image1 = 'images/maya.png';
  static const String image2 = 'images/2.jpg';
  static const String image3 = 'images/3.webp';
  static const String image4 = 'images/4.webp';
  static const String image5 = 'images/5.webp';
  static const String image6 = 'images/6.jpg';

  // Male preference images (9-12)
  static const String image9 = 'images/9.jfif';
  static const String image10 = 'images/10.jfif';
  static const String image11 = 'images/11.jpg';
  static const String image12 = 'images/12.jpg';

  // Female appearance images
  static const List<String> femalePreferenceImages = [
    image1,
    image2,
    image3,
    image4,
    image5,
    image6,
  ];

  // Male appearance images
  static const List<String> malePreferenceImages = [
    image9,
    image10,
    image11,
    image12,
  ];

  // All preference images (for backward compatibility)
  static const List<String> preferenceImages = [
    ...femalePreferenceImages,
    ...malePreferenceImages,
  ];
}
