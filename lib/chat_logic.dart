import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatLogic {
  late OpenAI openAI;

  ChatLogic({required String token}) {
    openAI = OpenAI.instance.build(
      token: token,
      baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 20),
          connectTimeout: const Duration(seconds: 20)),
      enableLog: true,
    );
  }

  Future<CompleteResponse?> translateEngToThai(String word) async {
    final request = CompleteText(
        prompt: translateEngToThai(word: word),
        maxTokens: 200,
        model: Gpt3TurboInstruct());
    return await openAI.onCompletion(request: request);
  }

  Future<ChatCTResponse?> gptFunctionCalling() async {
    final request = ChatCompleteText(
      messages: [
        Messages(
                role: Role.user,
                content: "What is the weather like in Boston?",
                name: "get_current_weather")
            .toJson(),
      ],
      maxToken: 200,
      model: Gpt41106PreviewChatModel(),
      tools: [
        {
          "type": "function",
          "function": {
            "name": "get_current_weather",
            "description": "Get the current weather in a given location",
            "parameters": {
              "type": "object",
              "properties": {
                "location": {
                  "type": "string",
                  "description": "The city and state, e.g. San Francisco, CA"
                },
                "unit": {
                  "type": "string",
                  "enum": ["celsius", "fahrenheit"]
                }
              },
              "required": ["location"]
            }
          }
        }
      ],
      toolChoice: 'auto',
    );

    return await openAI.onChatCompletion(request: request);
  }
}
