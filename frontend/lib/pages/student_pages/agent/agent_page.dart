import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Gemini Chat",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            onPressed: () {
              _sendMediaMessage();
            },
            icon: Icon(Icons.image),
          ),
        ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      // Check if the message has images
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];

        // If no text is provided with image, add default prompt
        if (question.isEmpty) {
          question =
              "What do you see in this image? Please describe it in detail.";
        }
      }

      // Send to Gemini with or without images
      gemini
          .streamGenerateContent(
            question,
            images:
                images, // This is the key fix - actually pass images to Gemini
          )
          .listen(
            (event) {
              String response =
                  event.content?.parts
                      ?.whereType<TextPart>()
                      .map((part) => part.text ?? "")
                      .join("") ??
                  "";

              if (response.isNotEmpty) {
                // Check if we already have a Gemini message in progress
                bool hasGeminiResponse =
                    messages.isNotEmpty && messages.first.user == geminiUser;

                if (hasGeminiResponse) {
                  // Update existing message
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
                  // Create new message
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
              // Add error message to chat
              ChatMessage errorMessage = ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text:
                    "Sorry, I encountered an error while processing your request.",
              );
              setState(() {
                messages = [errorMessage, ...messages];
              });
            },
          );
    } catch (e) {
      print("Error: $e");
      // Add error message to chat
      ChatMessage errorMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Sorry, something went wrong. Please try again.",
      );
      setState(() {
        messages = [errorMessage, ...messages];
      });
    }
  }

  Future<void> _sendMediaMessage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        final ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text:
              "", // Empty text, will be filled with default prompt in _sendMessage
          medias: [
            ChatMedia(
              url: file.path,
              fileName: file.name,
              type: MediaType.image,
            ),
          ],
        );

        // This will automatically trigger _sendMessage with the image
        _sendMessage(chatMessage);
      }
    } catch (e) {
      print("Image picker error: $e");
      // Show error to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to pick image: $e")));
    }
  }
}
