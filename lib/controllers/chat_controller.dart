import 'package:kraveai/services/elevenlabs_service.dart';
// import 'package:kraveai/services/bytez_audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/services/guest_service.dart';
import 'package:kraveai/services/openrouter_service.dart';
import 'package:kraveai/services/usage_tracking_service.dart';
// import 'package:kraveai/services/bytez_image_service.dart';
import 'package:kraveai/services/replicate_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kraveai/models/character_model.dart';

class ChatController extends GetxController {
  final SupabaseClient client = SupabaseService().client;

  // Observables
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final isImageGenerating = false.obs; // New observable

  // Guest Mode
  final RxBool isGuestUser = false.obs;
  final RxInt guestMessageCount = 0.obs;
  final RxBool guestLimitReached = false.obs;
  final GuestService _guestService = GuestService();

  // Image Generation (Legacy - now using usage tracking)
  final RxInt freeImageCount = 0.obs;
  final int maxFreeImages = 5;
  late SharedPreferences _prefs;

  // Usage Tracking for Registered Users
  final UsageTrackingService _usageService = UsageTrackingService();
  final RxBool isPremium = false.obs;
  final RxInt dailyMessageCount = 0.obs;
  final RxInt dailyImageCount = 0.obs;
  final RxInt dailyVoiceCount = 0.obs;
  final RxInt messageLimit = 10.obs;
  final RxInt imageLimit = 2.obs;
  final RxInt voiceLimit = 2.obs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
    _setupAudioListener();
    _loadUsageStats();
  }

  void _setupAudioListener() {
    // Set up a persistent listener for audio completion
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        debugPrint("DEBUG: Audio playback completed");
        playingMessageId.value = "";
      }
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    freeImageCount.value = _prefs.getInt('free_image_count') ?? 0;
  }

  /// Load usage statistics for registered users
  Future<void> _loadUsageStats() async {
    // Only for registered users
    if (client.auth.currentUser == null) return;

    try {
      // Check premium status
      isPremium.value = await _usageService.isPremiumUser();

      // Get current usage
      final usage = await _usageService.getCurrentUsage();
      dailyMessageCount.value = usage['messages'] ?? 0;
      dailyImageCount.value = usage['images'] ?? 0;
      dailyVoiceCount.value = usage['voice'] ?? 0;

      debugPrint(
        "✅ Usage stats loaded - Messages: ${dailyMessageCount.value}/10, Images: ${dailyImageCount.value}/2, Voice: ${dailyVoiceCount.value}/2, Premium: ${isPremium.value}",
      );
    } catch (e) {
      debugPrint("ERROR loading usage stats: $e");
    }
  }

  // Audio
  final AudioPlayer audioPlayer = AudioPlayer(); // Audio Player instance
  final RxString playingMessageId = "".obs; // Track which message is playing
  final isAudioLoading = false.obs;
  String? voiceId; // Store voice ID

  // Controllers
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final OpenRouterService _aiService = OpenRouterService();
  // final BytezAudioService _audioService = BytezAudioService(); // Audio Service
  final ElevenLabsService _audioService = ElevenLabsService();

  String? conversationId; // Nullable to handle initialization failures
  late String characterId;
  String? characterName;
  String? characterImage;
  String systemPrompt = "";
  Character? currentCharacter; // Store the full Character object

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void initializeRequest(
    String charId,
    String charName,
    String charImg, {
    Character? character,
  }) {
    characterId = charId;
    characterName = charName;
    characterImage = charImg;
    currentCharacter = character; // Store character object for image gen
    _getOrCreateConversation();
  }

  Future<void> _getOrCreateConversation() async {
    isLoading.value = true;
    try {
      // Check if user is in guest mode
      final currentUser = client.auth.currentUser;
      final isGuest = currentUser == null;
      isGuestUser.value = isGuest;

      String userId;
      String? guestSessionId;

      if (isGuest) {
        // Guest mode - use guest session
        debugPrint("DEBUG: User is in guest mode");
        final guestUser = _guestService.currentGuestUser;
        if (guestUser == null) {
          throw Exception('No guest session found');
        }
        guestSessionId = guestUser.sessionId;
        userId = 'guest_$guestSessionId'; // Temporary ID for guest
      } else {
        userId = currentUser.id;
      }

      debugPrint("DEBUG: Current User ID: $userId (Guest: $isGuest)");
      debugPrint("DEBUG: Target Character ID: $characterId");

      // 0. Fetch Character System Prompt AND Voice ID
      final charData = await client
          .from('characters')
          .select('system_prompt, voice_id')
          .eq('id', characterId)
          .single();
      systemPrompt = charData['system_prompt'] ?? "You are a helpful AI.";
      voiceId = charData['voice_id']; // Store voice ID
      // Hotfix: If DB still has old 'default_voice_id', fallback to Rachel
      if (voiceId == 'default_voice_id') {
        debugPrint(
          "DEBUG: Found invalid 'default_voice_id', swapping for Rachel.",
        );
        voiceId = '21m00Tcm4TlvDq8ikWAM';
      }
      debugPrint("DEBUG: Loaded System Prompt. Voice ID: $voiceId");

      // ... existing conversation logic ...
      final data = await client
          .from('conversations')
          .select()
          .eq(
            isGuest ? 'guest_session_id' : 'driver_user_id',
            isGuest ? (guestSessionId ?? '') : userId,
          )
          .eq('match_character_id', characterId)
          .maybeSingle();

      if (data != null) {
        conversationId = data['id'];
        debugPrint("DEBUG: Found existing conversation: $conversationId");

        // Load guest message count if guest
        if (isGuest) {
          guestMessageCount.value = await _guestService.getGuestMessageCount(
            conversationId!,
          );
          guestLimitReached.value = await _guestService.hasReachedLimit(
            conversationId!,
          );
          debugPrint(
            "DEBUG: Guest message count: ${guestMessageCount.value}/5",
          );
        }
      } else {
        // 2. Create new conversation
        debugPrint("DEBUG: Creating new conversation...");
        final insertData = {
          'match_character_id': characterId,
          'last_message': 'Started a new chat',
        };

        if (isGuest) {
          insertData['guest_session_id'] = guestSessionId ?? '';
        } else {
          insertData['driver_user_id'] = userId;
        }

        final newConv = await client
            .from('conversations')
            .insert(insertData)
            .select()
            .single();
        conversationId = newConv['id'];
        debugPrint("DEBUG: Created conversation: $conversationId");
      }

      // 3. Load Messages
      await _loadMessages();

      // 4. Subscribe to Realtime
      _subscribeToMessages();
    } catch (e) {
      debugPrint("DEBUG ERROR: Failed to init chat: $e");
      _showError('Failed to load chat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ... _loadMessages, _subscribeToMessages, sendMessage ...

  // Utility: Clean text by removing URLs
  String _cleanTextForDisplay(String text) {
    // Remove URLs (http/https)
    final urlPattern = RegExp(r'https?://[^\s]+', caseSensitive: false);
    return text.replaceAll(urlPattern, '').trim();
  }

  // Audio Playback Method
  Future<void> playMessageAudio(String messageId, String text) async {
    // Block audio for guest users
    if (isGuestUser.value) {
      Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            "Feature Locked",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Audio messages are available for registered users. Sign up to unlock voice messages and more!",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Maybe Later"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                // TODO: Navigate to registration
                Get.snackbar("Coming Soon", "Registration will be added soon!");
              },
              child: const Text("Sign Up", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return;
    }

    // Check voice limit for registered non-premium users
    if (!isGuestUser.value && !isPremium.value) {
      final canUse = await _usageService.canUseVoice();
      if (!canUse) {
        _showPremiumUpgradeDialog(
          title: "Daily Voice Limit Reached",
          message:
              "You've used 2 voice messages today. Upgrade to Premium for unlimited voice messages!",
          feature: "voice",
        );
        return;
      }
    }

    if (voiceId == null || voiceId!.isEmpty) {
      _showError("No voice configured for this character");
      return;
    }

    // Toggle off if already playing this message
    if (playingMessageId.value == messageId && audioPlayer.playing) {
      await audioPlayer.stop();
      playingMessageId.value = "";
      return;
    }

    try {
      isAudioLoading.value = true;
      playingMessageId.value = messageId; // Set current playing ID

      // Clean text before sending to audio service (remove URLs)
      final cleanText = _cleanTextForDisplay(text);

      debugPrint("DEBUG: Generating audio for: $cleanText");

      // generateAudio now returns a String URL (Blob URL for web, file path for mobile)
      final String? audioUrl = await _audioService.generateAudio(
        text: cleanText,
        voiceId: voiceId!,
      );

      if (audioUrl != null) {
        debugPrint("✅ Audio generated: $audioUrl");

        try {
          // Stop any currently playing audio first
          await audioPlayer.stop();

          // Set the new audio URL
          debugPrint("DEBUG: Setting audio URL...");
          await audioPlayer.setUrl(audioUrl);

          debugPrint("DEBUG: Playing audio...");
          await audioPlayer.play();

          debugPrint("✅ Audio playback started successfully");

          // Increment voice count for registered users (after successful play)
          if (!isGuestUser.value && !isPremium.value) {
            await _usageService.incrementVoiceCount();
            dailyVoiceCount.value =
                (await _usageService.getCurrentUsage())['voice'] ?? 0;
            debugPrint(
              "DEBUG: Voice count incremented: ${dailyVoiceCount.value}/2",
            );
          }
        } catch (e) {
          debugPrint("❌ Audio player error: $e");
          playingMessageId.value = "";
          _showError("Failed to play audio");
        }
      } else {
        debugPrint("ERROR: Failed to generate audio - audioUrl is null");
        playingMessageId.value = "";
      }
    } catch (e) {
      debugPrint("Audio Playback Error: $e");
      playingMessageId.value = "";
    } finally {
      isAudioLoading.value = false;
    }
  }

  Future<void> _loadMessages() async {
    if (conversationId == null) return; // Guard
    debugPrint("DEBUG: Loading messages for conversation $conversationId");
    final response = await client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId!)
        .order('created_at', ascending: true);

    debugPrint("DEBUG: Loaded ${response.length} messages");
    messages.assignAll(List<Map<String, dynamic>>.from(response));
    _scrollToBottom();
  }

  void _subscribeToMessages() {
    if (conversationId == null) return; // Guard
    debugPrint("DEBUG: Subscribing to messages...");
    client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId!)
        .order('created_at')
        .listen((List<Map<String, dynamic>> data) {
          debugPrint(
            "DEBUG: Realtime update received! ${data.length} messages.",
          );
          // Merge or replace
          messages.assignAll(data);
          _scrollToBottom();
        });
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    // 0. CHECK CONVERSATION INITIALIZED
    if (conversationId == null) {
      debugPrint("❌ ERROR: Conversation not initialized yet");
      _showError('Failed to initialize chat. Please try reloading.');
      return;
    }

    // 1. CHECK GUEST LIMIT FIRST
    if (isGuestUser.value) {
      if (guestLimitReached.value) {
        debugPrint("DEBUG: Guest limit already reached");
        return; // Don't send message, blurred image already shown
      }

      if (guestMessageCount.value >= 5) {
        debugPrint("DEBUG: Guest reached 5 messages, showing blurred image");
        guestLimitReached.value = true;

        // Add blurred image message
        await _addGuestLimitMessage();
        return;
      }
    }

    // 2. CHECK REGULAR LIMIT (for registered users)
    if (!isGuestUser.value) {
      // Check if premium user
      final premium = await _usageService.isPremiumUser();
      isPremium.value = premium;

      if (!premium) {
        // Check daily message limit for non-premium users
        final canSend = await _usageService.canSendMessage();
        if (!canSend) {
          _showPremiumUpgradeDialog(
            title: "Daily Message Limit Reached",
            message:
                "You've sent 10 messages today. Upgrade to Premium for unlimited messages!",
            feature: "messages",
          );
          return;
        }
      }
    }

    debugPrint("DEBUG: Sending message: $text");
    textController.clear();
    isSending.value = true;

    // 1. Optimistic User Update
    final tempUserMsgId = 'temp-user-${DateTime.now().millisecondsSinceEpoch}';
    final tempUserMessage = {
      'id': tempUserMsgId,
      'conversation_id': conversationId!,
      'sender_type': 'user',
      'content': text,
      'created_at': DateTime.now().toIso8601String(),
    };
    messages.add(tempUserMessage);
    _scrollToBottom();

    try {
      // 2. Insert User Message to DB (Retry Wrapper)
      await _performSupabaseOperation(() async {
        await client.from('messages').insert({
          'conversation_id': conversationId!,
          'sender_type': 'user',
          'content': text,
        }).select();
      });

      // 2.5 Increment guest message count if guest
      if (isGuestUser.value) {
        await _guestService.incrementGuestMessageCount(conversationId!);
        guestMessageCount.value = await _guestService.getGuestMessageCount(
          conversationId!,
        );
        debugPrint(
          "DEBUG: Guest message count after send: ${guestMessageCount.value}/5",
        );
      } else {
        // Increment registered user message count
        await _usageService.incrementMessageCount();
        dailyMessageCount.value =
            (await _usageService.getCurrentUsage())['messages'] ?? 0;
        debugPrint(
          "DEBUG: Registered user message count: ${dailyMessageCount.value}/10",
        );
      }

      // 3. Get AI Response
      final responseText = await _aiService.getChatCompletion(
        userMessage: text,
        systemPrompt: systemPrompt,
        history: messages,
      );

      if (responseText != null) {
        debugPrint("DEBUG: AI Response: $responseText");

        // Clean the response text (remove URLs)
        final cleanResponseText = _cleanTextForDisplay(responseText);

        // 4. Optimistic AI Update (Show immediately with cleaned text)
        final tempAiMsgId = 'temp-ai-${DateTime.now().millisecondsSinceEpoch}';
        final tempAiMessage = {
          'id': tempAiMsgId,
          'conversation_id': conversationId!,
          'sender_type': 'character',
          'content': cleanResponseText,
          'created_at': DateTime.now().toIso8601String(),
        };
        messages.add(tempAiMessage);
        _scrollToBottom();

        // 5. Background AI Save (Fire & Forget)
        // We don't await this to keep UI responsive, but we catch errors.
        _performSupabaseOperation(() async {
          await client.from('messages').insert({
            'conversation_id': conversationId!,
            'sender_type': 'character',
            'content': cleanResponseText,
          });

          // 6. Update Conversation Last Message
          await client
              .from('conversations')
              .update({
                'last_message': cleanResponseText,
                'last_message_at': DateTime.now().toIso8601String(),
              })
              .eq('id', conversationId!);
        }).catchError((e) {
          debugPrint("DEBUG ERROR: Background AI save failed: $e");
        });
      }
    } catch (e) {
      debugPrint("DEBUG ERROR: Send failed: $e");
      // Remove temp message if failed
      messages.removeWhere((m) => m['id'] == tempUserMsgId);

      // Safe Snackbar
      _showError('Failed to send. Please check your connection.');
    } finally {
      isSending.value = false;
    }
  }

  Future<void> _performSupabaseOperation(
    Future<void> Function() operation,
  ) async {
    int retryCount = 0;
    const maxRetries = 3;
    while (retryCount < maxRetries) {
      try {
        await operation();
        return;
      } catch (e) {
        debugPrint("Supabase op failed (attempt ${retryCount + 1}): $e");
        retryCount++;
        if (retryCount >= maxRetries) rethrow;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  // Helper for safe UI updates
  void _showError(String message) {
    debugPrint("⚠️ Error: $message");

    // Use post frame callback to ensure overlay exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Check if Get context exists and is mounted
        if (Get.context != null && Get.isRegistered<ChatController>()) {
          final controller = Get.find<ChatController>();
          // Only show snackbar if we're still in the widget tree
          if (controller.isClosed == false) {
            Get.snackbar(
              'Error',
              message,
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(10),
              duration: const Duration(seconds: 3),
            );
          }
        } else {
          debugPrint("Suppressed Snackbar (No Context): $message");
        }
      } catch (e) {
        debugPrint("Error showing snackbar: $e - Original message: $message");
      }
    });
  }

  // Show premium upgrade dialog
  void _showPremiumUpgradeDialog({
    required String title,
    required String message,
    required String feature,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Row(
          children: [
            const Icon(Icons.workspace_premium, color: Colors.amber, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              if (Get.isDialogOpen == true) {
                Get.back();
              }
            },
            child: const Text("Maybe Later"),
          ),
          TextButton(
            onPressed: () {
              if (Get.isDialogOpen == true) {
                Get.back();
              }
            },
            child: const Text(
              "Upgrade to Premium",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Image Generation Method
  Future<void> requestImage() async {
    // 0. Block image generation for guest users
    if (isGuestUser.value) {
      Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            "Feature Locked",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Photo generation is available for registered users. Sign up to unlock photos and more features!",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Maybe Later"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                // TODO: Navigate to registration
                Get.snackbar("Coming Soon", "Registration will be added soon!");
              },
              child: const Text("Sign Up", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return;
    }

    // 1. Check Daily Image Limit for non-premium users
    if (!isPremium.value) {
      final canGenerate = await _usageService.canGenerateImage();
      if (!canGenerate) {
        _showPremiumUpgradeDialog(
          title: "Daily Image Limit Reached",
          message:
              "You've generated 2 images today. Upgrade to Premium for unlimited images!",
          feature: "images",
        );
        return;
      }
    }

    isImageGenerating.value = true;

    // 2. Generate contextual prompt using character's physical description
    // Extract context from last few messages for dynamic scenarios
    String contextHint = "selfie, looking at camera";
    if (messages.length >= 2) {
      final recentMessages = messages.reversed.take(3).toList();
      for (var msg in recentMessages) {
        final content = (msg['content'] ?? '').toString().toLowerCase();
        if (content.contains('bed') || content.contains('bedroom')) {
          contextHint = "lying in bed, bedroom setting";
          break;
        } else if (content.contains('dress') || content.contains('outfit')) {
          contextHint = "wearing elegant outfit, full body pose";
          break;
        } else if (content.contains('beach') || content.contains('pool')) {
          contextHint = "at the beach, outdoor setting";
          break;
        }
      }
    }

    // Use character's detailed appearance description
    final baseAppearance =
        currentCharacter?.imagePromptDescription ??
        "beautiful woman with ${characterName ?? 'attractive'} features";

    final imagePrompt =
        "$baseAppearance, $contextHint, flirty expression, cinematic lighting, high quality, photorealistic";
    debugPrint("DEBUG: Image Generation Prompt: $imagePrompt");

    try {
      // 3. Optimistic "Generating..." Message
      final tempId = 'temp-img-${DateTime.now().millisecondsSinceEpoch}';
      final tempMsg = {
        'id': tempId,
        'conversation_id': conversationId!,
        'sender_type': 'image', // Special type
        'content': 'Generating photo...',
        'created_at': DateTime.now().toIso8601String(),
        'is_loading': true, // Local flag
      };
      messages.add(tempMsg);
      _scrollToBottom();

      // 4. Call Service
      // final imageUrl = await BytezImageService().generateImage(imagePrompt);
      final imageUrl = await ReplicateService().generateImage(imagePrompt);

      // Remove temp
      messages.removeWhere((m) => m['id'] == tempId);

      if (imageUrl != null) {
        // 5. Success! Save to DB
        await _performSupabaseOperation(() async {
          await client.from('messages').insert({
            'conversation_id': conversationId!,
            'sender_type': 'image', // Vital for UI
            'content': imageUrl,
          });
        });

        // 6. Increment Image Count
        if (!isPremium.value) {
          await _usageService.incrementImageCount();
          dailyImageCount.value =
              (await _usageService.getCurrentUsage())['images'] ?? 0;
          debugPrint(
            "DEBUG: Image count incremented: ${dailyImageCount.value}/2",
          );
        }

        // Legacy: Also keep track of old free image count for backward compatibility
        freeImageCount.value++;
        await _prefs.setInt('free_image_count', freeImageCount.value);

        // 7. Add to local list immediately
        messages.add({
          'conversation_id': conversationId!,
          'sender_type': 'image',
          'content': imageUrl,
          'created_at': DateTime.now().toIso8601String(),
        });
        _scrollToBottom();
      } else {
        debugPrint("ERROR: Image generation returned null");
        _showError("Failed to generate image. Please try again.");
      }
    } catch (e) {
      debugPrint("Image Gen Error: $e");
      _showError("Could not generate image");
    } finally {
      isImageGenerating.value = false;
    }
  }

  // Add guest limit reached message with blurred image
  Future<void> _addGuestLimitMessage() async {
    try {
      // 1. Add blurred image message (using character image as base)
      final blurredImageMsg = {
        'id': 'guest-limit-${DateTime.now().millisecondsSinceEpoch}',
        'conversation_id': conversationId!,
        'sender_type': 'guest_limit', // Special type for registration prompt
        'content':
            characterImage ??
            '', // Use character's image (will be blurred in UI)
        'created_at': DateTime.now().toIso8601String(),
      };
      messages.add(blurredImageMsg);
      _scrollToBottom();

      // 2. Save to database
      await _performSupabaseOperation(() async {
        await client.from('messages').insert({
          'conversation_id': conversationId!,
          'sender_type': 'guest_limit',
          'content': characterImage ?? '',
        });
      });

      debugPrint("✅ Guest limit message added");
    } catch (e) {
      debugPrint("❌ Failed to add guest limit message: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
