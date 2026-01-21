import 'dart:ui';

import 'package:get/get.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/models/user_profile_model.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/screens/dashboard/dashboard_screen.dart';
import 'package:kraveai/views/widgets/my_button.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/my_text_field.dart';
import 'package:kraveai/services/usage_tracking_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  UserProfile? userProfile;
  String? userEmail;
  String? selectedRole;

  // Stats
  int messageCount = 0;
  int imageGenCount = 0;
  int voiceGenCount = 0;
  int userLevel = 1; // Default for guest

  // Available roles
  final List<String> availableRoles = [
    'Friend',
    'Romantic Partner',
    'Therapist',
    'Mentor',
    'Creative Partner',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoading = true);

    try {
      final user = _supabaseService.currentUser;
      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      // Get email from auth
      userEmail = user.email;
      _emailController.text = userEmail ?? '';

      // Get profile from database
      userProfile = await _supabaseService.getUserProfile();

      if (userProfile != null) {
        _nameController.text = userProfile!.displayName ?? '';
        selectedRole = userProfile!.preferredRole;

        // Set user level based on authentication
        userLevel = user.appMetadata.isEmpty ? 1 : 3;

        // Validation: Ensure selectedRole is in availableRoles to prevent crash
        if (selectedRole != null &&
            selectedRole!.isNotEmpty &&
            !availableRoles.contains(selectedRole)) {
          availableRoles.add(selectedRole!);
        }
      } else {
        // If profile doesn't exist, try to populate from auth metadata
        final metadata = user.userMetadata;
        if (metadata != null) {
          if (metadata['full_name'] != null) {
            _nameController.text = metadata['full_name'];
          }
          if (metadata['role'] != null) {
            selectedRole = metadata['role'];
            // Check availability for metadata role too
            if (selectedRole != null &&
                selectedRole!.isNotEmpty &&
                !availableRoles.contains(selectedRole)) {
              availableRoles.add(selectedRole!);
            }
          }
        }
      }

      // Load usage stats from database
      await _loadStats(user.id);

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint('Error loading profile: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadStats(String userId) async {
    try {
      final usageTracking = UsageTrackingService();
      final usage = await usageTracking.getCurrentUsage();

      messageCount = usage['messages'] ?? 0;
      imageGenCount = usage['images'] ?? 0;
      voiceGenCount = usage['voice'] ?? 0;

      setState(() {});
    } catch (e) {
      debugPrint('Error loading stats: $e');
    }
  }

  Future<void> _saveProfile() async {
    final user = _supabaseService.currentUser;
    if (user == null) return;

    setState(() => isSaving = true);

    final success = await _supabaseService.updateUserProfile(
      userId: user.id,
      displayName: _nameController.text.trim(),
      preferredRole: selectedRole,
    );

    setState(() => isSaving = false);

    if (success) {
      Get.snackbar(
        "Success",
        "Profile updated!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Navigate to homepage
      Get.offAll(() => const CustomBottomNav());
    } else {
      Get.snackbar(
        "Error",
        "Failed to update profile",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.secondary),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: MyText(text: "My Profile", size: 20),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Column(
                  children: [
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person_2_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyTextField(
                        controller: _nameController,
                        hint: "Your Name",
                        radius: 12,
                        label: "Display Name",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyTextField(
                        controller: _emailController,
                        hint: "your@email.com",
                        radius: 12,
                        label: "Email",
                        isReadOnly: true, // Make email read-only
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: MyText(
                          text: "Email Can,t be changed",
                          size: 10,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                // Preferred Role Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: "Preferred Role",
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: selectedRole,
                          hint: MyText(
                            text: "Select how you want AI to support you",
                            size: 14,
                          ),
                          isExpanded: true,
                          underline: SizedBox(),
                          dropdownColor: AppColors.background,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          items: availableRoles.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: MyText(text: role, size: 14),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Stats Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Stats",
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(height: 20),
                          _statRow(
                            "User Level",
                            "Level $userLevel",
                            Icons.stars,
                          ),
                          const SizedBox(height: 16),
                          _statRow(
                            "Messages Sent",
                            "$messageCount",
                            Icons.message,
                          ),
                          const SizedBox(height: 16),
                          _statRow(
                            "Images Generated",
                            "$imageGenCount",
                            Icons.image,
                          ),
                          const SizedBox(height: 16),
                          _statRow(
                            "Voice Messages",
                            "$voiceGenCount",
                            Icons.volume_up,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: isSaving
                      ? CircularProgressIndicator(color: AppColors.primary)
                      : MyButton(
                          onTap: _saveProfile,
                          buttonText: "Save Changes",
                          radius: 12,
                        ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: MyText(text: label, size: 14)),
        MyText(
          text: value,
          size: 14,
          weight: FontWeight.w600,
          color: AppColors.secondary,
        ),
      ],
    );
  }
}
