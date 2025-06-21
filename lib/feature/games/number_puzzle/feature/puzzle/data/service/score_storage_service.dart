import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorageService {
  static const String _bestScoreKeyPrefix = 'number_puzzle_best_score_';
  
  /// Save best score for a specific difficulty
  Future<bool> saveBestScore(DifficultyType difficulty, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(difficulty);
    final currentBestScore = await getBestScore(difficulty) ?? 0;
    
    // Only save if the new score is higher
    if (score > currentBestScore) {
      return prefs.setInt(key, score);
    }
    return false;
  }
  
  /// Get the best score for a specific difficulty
  Future<int?> getBestScore(DifficultyType difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(difficulty);
    return prefs.getInt(key);
  }
  
  /// Generate a key for storing scores based on difficulty
  String _getKey(DifficultyType difficulty) {
    return _bestScoreKeyPrefix + difficulty.toString().split('.').last;
  }
}
