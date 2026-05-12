import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // TODO: 실제 Gemini API Key로 교체해야 작동합니다.
  static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  static Future<Map<String, dynamic>?> extractBeanInfo(Uint8List imageBytes, String mimeType) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      debugPrint('Please provide a valid Gemini API Key in gemini_service.dart.');
      return null;
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
      );

      final prompt = TextPart('''
이 사진은 커피 원두 패키지입니다. 사진의 텍스트를 읽고 다음 정보를 추출해서 오직 JSON 형식으로만 반환하세요.
마크다운 포맷(```json ... ```)을 사용하지 말고 순수한 JSON 문자열만 반환하세요.

추출할 필드:
- "name": 원두의 이름 (예: "콜롬비아 수프리모", "예가체프 아리차" 등)
- "roaster": 로스터리 또는 브랜드 이름 (예: "스타벅스", "나무사이로", "모모스커피" 등)
- "roastDate": 로스팅 날짜가 있다면 YYYY-MM-DD 형식으로 반환. 없으면 null.
- "weight": 내용량 또는 중량이 있다면 숫자만 반환 (예: 200g 이면 200). 없으면 null.
- "flavorNotes": 컵 노트나 테이스팅 노트가 있다면 하나의 문자열로 쉼표로 구분하여 반환. 없으면 null.

출력 예시:
{
  "name": "에티오피아 예가체프",
  "roaster": "빈브라더스",
  "roastDate": "2024-05-10",
  "weight": 200,
  "flavorNotes": "복숭아, 꿀, 플로럴"
}
''');
      
      final imagePart = DataPart(mimeType, imageBytes);
      
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      if (response.text != null) {
        String jsonText = response.text!.trim();
        // 혹시 마크다운 블록이 포함되어 반환된 경우 처리
        if (jsonText.startsWith('```json')) {
          jsonText = jsonText.substring(7);
        }
        if (jsonText.startsWith('```')) {
          jsonText = jsonText.substring(3);
        }
        if (jsonText.endsWith('```')) {
          jsonText = jsonText.substring(0, jsonText.length - 3);
        }
        
        return jsonDecode(jsonText.trim()) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Gemini API Error: $e');
    }
    return null;
  }
}
