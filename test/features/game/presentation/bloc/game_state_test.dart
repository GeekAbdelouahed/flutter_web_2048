import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_2048/features/game/domain/entities/board.dart';
import 'package:flutter_web_2048/features/game/domain/entities/tile.dart';

import 'package:flutter_web_2048/features/game/presentation/bloc/game_state.dart';
import 'package:piecemeal/piecemeal.dart';

void main() {
  group('GameOver', () {
    test('should extend GameState', () {
      // ARRANGE
      var board = Board(Array2D<Tile>(4, 4));
      // ACT
      var gameOver = GameOverState(board);
      // ASSERT
      expect(gameOver, isA<GameState>());
    });
    test('should have props list with the board', () {
      // ARRANGE
      var board = Board(Array2D<Tile>(4, 4));
      var expected = <Object>[board];
      // ACT
      var gameOver = GameOverState(board);
      // ASSERT
      expect(gameOver.props, expected);
    });
  });
  group('HighscoreLoaded', () {
    test('should extend GameState', () {
      // ARRANGE
      int highscore = 9000;
      // ACT
      var state = HighscoreLoadedState(highscore);
      // ASSERT
      expect(state, isA<GameState>());
    });
    test('should have props list with the board and highscore', () {
      // ARRANGE
      int highscore = 9000;
      var expected = <Object>[highscore];
      // ACT
      var state = HighscoreLoadedState(highscore);
      // ASSERT
      expect(state.props, expected);
    });
  });
  group('Error', () {
    test('should extend GameState', () {
      // ARRANGE
      String message = 'message';
      // ACT
      var error = GameErrorState(message);
      // ASSERT
      expect(error, isA<GameState>());
    });
    test('should have a props list with the message', () {
      // ARRANGE
      String message = 'message';
      var expected = <Object>[message];
      // ACT
      var error = GameErrorState(message);
      // ASSERT
      expect(error.props, expected);
    });
  });
}
