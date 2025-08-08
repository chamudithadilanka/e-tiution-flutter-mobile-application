// import 'dart:io';
// import 'dart:typed_data';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:frontend/utils/colors.dart';
// import 'package:image_picker/image_picker.dart';

// class AgentPage extends StatefulWidget {
//   const AgentPage({super.key});

//   @override
//   State<AgentPage> createState() => _AgentPageState();
// }

// class _AgentPageState extends State<AgentPage> {
//   Gemini gemini = Gemini.instance;
//   List<ChatMessage> messages = [];
//   ChatUser currentUser = ChatUser(id: "0", firstName: "User");
//   ChatUser geminiUser = ChatUser(
//     id: "1",
//     firstName: "Gemini",
//     profileImage: "",
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kMainWhiteColor,
//         centerTitle: true,
//         title: Text(
//           "Self Leaning Bot",
//           style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/images/3d-delivery-robot-working.jpg"),
//           fit: BoxFit.cover,
//         ),
//         gradient: LinearGradient(
//           colors: [kMainDarkBlue, kMainColor],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: DashChat(
//         messageOptions: MessageOptions(
//           // Add this configuration
//           currentUserContainerColor: Colors.white,
//           containerColor: Colors.white,
//           textColor: Colors.black, // Set text color for readability
//           currentUserTextColor: Colors.black,
//         ),
//         inputOptions: InputOptions(
//           trailing: [
//             IconButton(
//               onPressed: _sendMediaMessage,
//               icon: Icon(
//                 Icons.image,
//                 color: Colors.white,
//               ), // Make icon visible on gradient
//             ),
//           ],
//           inputTextStyle: TextStyle(color: Colors.black), // Input text color
//           inputDecoration: InputDecoration(
//             hintText: "Enter Your Prompt",
//             filled: true,
//             fillColor: Colors.white.withOpacity(0.9), // White input background
//             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             border: OutlineInputBorder(
//               borderSide: BorderSide.none,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             hintStyle: TextStyle(color: Colors.blueGrey),
//           ),
//         ),
//         currentUser: currentUser,
//         onSend: _sendMessage,
//         messages: messages,
//       ),
//     );
//   }

//   void _sendMessage(ChatMessage chatMessage) {
//     setState(() {
//       messages = [chatMessage, ...messages];
//     });

//     try {
//       String question = chatMessage.text;
//       List<Uint8List>? images;

//       // Check if the message has images
//       if (chatMessage.medias?.isNotEmpty ?? false) {
//         images = [File(chatMessage.medias!.first.url).readAsBytesSync()];

//         // If no text is provided with image, add default prompt
//         if (question.isEmpty) {
//           question =
//               "What do you see in this image? Please describe it in detail.";
//         }
//       }

//       // Send to Gemini with or without images
//       gemini
//           .streamGenerateContent(
//             question,
//             images:
//                 images, // This is the key fix - actually pass images to Gemini
//           )
//           .listen(
//             (event) {
//               String response =
//                   event.content?.parts
//                       ?.whereType<TextPart>()
//                       .map((part) => part.text ?? "")
//                       .join("") ??
//                   "";

//               if (response.isNotEmpty) {
//                 // Check if we already have a Gemini message in progress
//                 bool hasGeminiResponse =
//                     messages.isNotEmpty && messages.first.user == geminiUser;

//                 if (hasGeminiResponse) {
//                   // Update existing message
//                   setState(() {
//                     messages = [
//                       ChatMessage(
//                         user: geminiUser,
//                         createdAt: messages.first.createdAt,
//                         text: messages.first.text + response,
//                       ),
//                       ...messages.sublist(1),
//                     ];
//                   });
//                 } else {
//                   // Create new message
//                   ChatMessage message = ChatMessage(
//                     user: geminiUser,
//                     createdAt: DateTime.now(),
//                     text: response,
//                   );
//                   setState(() {
//                     messages = [message, ...messages];
//                   });
//                 }
//               }
//             },
//             onError: (error) {
//               print("Gemini Error: $error");
//               // Add error message to chat
//               ChatMessage errorMessage = ChatMessage(
//                 user: geminiUser,
//                 createdAt: DateTime.now(),
//                 text:
//                     "Sorry, I encountered an error while processing your request.",
//               );
//               setState(() {
//                 messages = [errorMessage, ...messages];
//               });
//             },
//           );
//     } catch (e) {
//       print("Error: $e");
//       // Add error message to chat
//       ChatMessage errorMessage = ChatMessage(
//         user: geminiUser,
//         createdAt: DateTime.now(),
//         text: "Sorry, something went wrong. Please try again.",
//       );
//       setState(() {
//         messages = [errorMessage, ...messages];
//       });
//     }
//   }

//   Future<void> _sendMediaMessage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? file = await picker.pickImage(source: ImageSource.gallery);

//       if (file != null) {
//         final ChatMessage chatMessage = ChatMessage(
//           user: currentUser,
//           createdAt: DateTime.now(),
//           text:
//               "", // Empty text, will be filled with default prompt in _sendMessage
//           medias: [
//             ChatMedia(
//               url: file.path,
//               fileName: file.name,
//               type: MediaType.image,
//             ),
//           ],
//         );

//         // This will automatically trigger _sendMessage with the image
//         _sendMessage(chatMessage);
//       }
//     } catch (e) {
//       print("Image picker error: $e");
//       // Show error to user
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed to pick image: $e")));
//     }
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:frontend/utils/colors.dart';
import 'package:image_picker/image_picker.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "User",
    profileImage:
        "assets/images/Leonardo_Phoenix_09_Image_features_a_3D_digital_illustration_o_3 (1).jpg", // Option 1: Asset image
    // profileImage: "https://example.com/avatar.jpg", // Option 2: Network image
  );
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "EduBot",
    profileImage:
        "assets/images/Leonardo_Phoenix_09_Image_features_a_3D_digital_illustration_o_3 (1).jpg", // Bot avatar
  );

  // Educational limitations
  int dailyMessageCount = 0;
  static const int maxDailyMessages = 50;
  static const int maxMessageLength = 500;
  DateTime? lastResetDate;

  // Restricted topics keywords
  final List<String> restrictedKeywords = [
    'hack',
    'hacking',
    'crack',
    'cracking',
    'piracy',
    'illegal',
    'drugs',
    'weapon',
    'bomb',
    'violence',
    'adult',
    'nsfw',
    'cheat',
    'fraud',
    'scam',
    'plagiarism',
    'copyright infringement',
  ];

  // Educational topics that are encouraged
  final List<String> educationalTopics = [
    'mathematics',
    'science',
    'physics',
    'chemistry',
    'biology',
    'history',
    'literature',
    'programming',
    'computer science',
    'engineering',
    'art',
    'music',
    'language learning',
    'study tips',
  ];

  // Profile image management
  String? userProfileImagePath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _resetDailyCountIfNeeded();
    _loadUserProfile();
    _showWelcomeMessage();
  }

  // Load user profile (you can implement SharedPreferences here)
  void _loadUserProfile() {
    // TODO: Load from SharedPreferences or database
    // For now, using default asset
  }

  // Method to change user profile picture
  Future<void> _changeUserProfilePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 200,
        maxHeight: 200,
      );

      if (image != null) {
        setState(() {
          userProfileImagePath = image.path;
          currentUser = ChatUser(
            id: "0",
            firstName: "User",
            profileImage: image.path,
          );
        });

        // TODO: Save to SharedPreferences
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('user_profile_image', image.path);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile picture updated!")));
      }
    } catch (e) {
      print("Error picking profile image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile picture")),
      );
    }
  }

  void _resetDailyCountIfNeeded() {
    DateTime today = DateTime.now();
    if (lastResetDate == null ||
        lastResetDate!.day != today.day ||
        lastResetDate!.month != today.month ||
        lastResetDate!.year != today.year) {
      dailyMessageCount = 0;
      lastResetDate = today;
    }
  }

  void _showWelcomeMessage() {
    ChatMessage welcomeMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text:
          "Welcome to EduBot! 🎓\n\n"
          "I'm here to help you learn! Here are my guidelines:\n"
          "• Daily limit: ${maxDailyMessages} messages\n"
          "• Message limit: ${maxMessageLength} characters\n"
          "• Focus on educational topics\n"
          "• Ask about: math, science, programming, history, etc.\n\n"
          "How can I help you learn today?",
    );
    setState(() {
      messages = [welcomeMessage];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainWhiteColor,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Educational Learning Bot",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Text(
              "Messages today: $dailyMessageCount/$maxDailyMessages",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          // Profile settings button
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'change_profile') {
                _changeUserProfilePicture();
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'change_profile',
                    child: Row(
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(width: 8),
                        Text('Change Profile Picture'),
                      ],
                    ),
                  ),
                ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/3d-delivery-robot-working.jpg"),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [kMainDarkBlue, kMainColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
      child: DashChat(
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.white,
          containerColor: Colors.white,
          textColor: Colors.black,
          currentUserTextColor: Colors.black,
        ),
        inputOptions: InputOptions(
          trailing: [
            IconButton(
              onPressed: _canSendMessage() ? _sendMediaMessage : null,
              icon: Icon(
                Icons.image,
                color: _canSendMessage() ? Colors.white : Colors.grey,
              ),
            ),
          ],
          inputTextStyle: TextStyle(color: Colors.black),
          inputDecoration: InputDecoration(
            hintText:
                _canSendMessage()
                    ? "Ask an educational question..."
                    : "Daily limit reached",
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            hintStyle: TextStyle(color: Colors.blueGrey),
          ),
        ),
        currentUser: currentUser,
        onSend: _handleMessageSend,
        messages: messages,
      ),
    );
  }

  bool _canSendMessage() {
    _resetDailyCountIfNeeded();
    return dailyMessageCount < maxDailyMessages;
  }

  bool _isEducationalContent(String text) {
    String lowerText = text.toLowerCase();

    // Check for educational keywords
    bool hasEducationalKeywords = educationalTopics.any(
      (topic) => lowerText.contains(topic.toLowerCase()),
    );

    // Check for question words (educational intent)
    bool hasQuestionWords = [
      'hi',
      'what',
      'how',
      'why',
      'when',
      'where',
      'explain',
      'teach',
      'learn',
      'understand',
      'help me with',
    ].any((word) => lowerText.contains(word));

    return hasEducationalKeywords ||
        hasQuestionWords ||
        lowerText.contains('?');
  }

  bool _containsRestrictedContent(String text) {
    String lowerText = text.toLowerCase();
    return restrictedKeywords.any(
      (keyword) => lowerText.contains(keyword.toLowerCase()),
    );
  }

  void _handleMessageSend(ChatMessage chatMessage) {
    // Check daily limit
    if (!_canSendMessage()) {
      _showLimitMessage("Daily message limit reached! Try again tomorrow.");
      return;
    }

    // Check message length
    if (chatMessage.text.length > maxMessageLength) {
      _showLimitMessage(
        "Message too long! Please keep it under $maxMessageLength characters.",
      );
      return;
    }

    // Check for restricted content
    if (_containsRestrictedContent(chatMessage.text)) {
      _showLimitMessage(
        "I can only help with educational topics. Please ask about learning, "
        "academics, or educational subjects.",
      );
      return;
    }

    // Encourage educational content
    if (!_isEducationalContent(chatMessage.text) &&
        chatMessage.text.isNotEmpty) {
      _showSuggestionMessage();
      return;
    }

    // Increment counter and send message
    setState(() {
      dailyMessageCount++;
    });

    _sendMessage(chatMessage);
  }

  void _showLimitMessage(String message) {
    ChatMessage limitMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "⚠️ $message",
    );
    setState(() {
      messages = [limitMessage, ...messages];
    });
  }

  void _showSuggestionMessage() {
    ChatMessage suggestionMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text:
          "🎓 I'm designed to help with educational topics! Try asking about:\n\n"
          "📚 Academic subjects (math, science, history)\n"
          "💻 Programming and computer science\n"
          "🔬 Research and study methods\n"
          "🎨 Arts and creative learning\n"
          "🌍 Language learning\n\n"
          "What would you like to learn about?",
    );
    setState(() {
      messages = [suggestionMessage, ...messages];
    });
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      // Add educational context to the prompt
      String educationalPrompt =
          "As an educational assistant, please provide "
          "a helpful, accurate, and educational response to: $question";

      // Check if the message has images
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];

        if (question.isEmpty) {
          educationalPrompt =
              "Please analyze this image from an educational "
              "perspective. What can we learn from it? Describe its educational "
              "value and any academic concepts it might illustrate.";
        }
      }

      // Send to Gemini with educational context
      gemini
          .streamGenerateContent(educationalPrompt, images: images)
          .listen(
            (event) {
              String response =
                  event.content?.parts
                      ?.whereType<TextPart>()
                      .map((part) => part.text ?? "")
                      .join("") ??
                  "";

              if (response.isNotEmpty) {
                bool hasGeminiResponse =
                    messages.isNotEmpty && messages.first.user == geminiUser;

                if (hasGeminiResponse) {
                  setState(() {
                    messages = [
                      ChatMessage(
                        user: geminiUser,
                        createdAt: messages.first.createdAt,
                        text: messages.first.text + response,
                      ),
                      ...messages.sublist(1),
                    ];
                  });
                } else {
                  ChatMessage message = ChatMessage(
                    user: geminiUser,
                    createdAt: DateTime.now(),
                    text: response,
                  );
                  setState(() {
                    messages = [message, ...messages];
                  });
                }
              }
            },
            onError: (error) {
              print("Gemini Error: $error");
              ChatMessage errorMessage = ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text:
                    "Sorry, I encountered an error while processing your "
                    "educational request. Please try again.",
              );
              setState(() {
                messages = [errorMessage, ...messages];
              });
            },
          );
    } catch (e) {
      print("Error: $e");
      ChatMessage errorMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text:
            "Sorry, something went wrong. Please try again with an "
            "educational question.",
      );
      setState(() {
        messages = [errorMessage, ...messages];
      });
    }
  }

  Future<void> _sendMediaMessage() async {
    if (!_canSendMessage()) {
      _showLimitMessage("Daily message limit reached!");
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        final ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "",
          medias: [
            ChatMedia(
              url: file.path,
              fileName: file.name,
              type: MediaType.image,
            ),
          ],
        );

        // Increment counter for image messages too
        setState(() {
          dailyMessageCount++;
        });

        _sendMessage(chatMessage);
      }
    } catch (e) {
      print("Image picker error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to pick image: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
