import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_2048/features/game/domain/entities/destination.dart';
import 'package:flutter_web_2048/features/game/domain/entities/tile.dart';

void main() {
  group('fromDestination', () {
    test('should return tile with x and y from destination', () {
      // ARRANGE
      int value = 2;
      var destination = Destination(
        x: 0,
        y: 0,
        hasMerged: false,
        hasMoved: false,
      );
      // ACT
      var tile = Tile.fromDestination(value, destination);
      // ASSERT
      expect(tile.x, destination.x);
      expect(tile.y, destination.y);
    });
    group('nomerge', () {
      test('should set [Tile.merged] to false', () {
        // ARRANGE
        int value = 2;
        var destination = Destination(
          x: 0,
          y: 0,
          hasMerged: false,
          hasMoved: false,
        );
        // ACT
        var tile = Tile.fromDestination(value, destination);
        // ASSERT
        expect(tile.merged, false);
      });
      test('should return the same value', () {
        // ARRANGE
        int value = 2;
        var destination = Destination(
          x: 0,
          y: 0,
          hasMerged: false,
          hasMoved: false,
        );
        // ACT
        var tile = Tile.fromDestination(value, destination);
        // ASSERT
        expect(tile.value, value);
      });
    });

    group('merge', () {
      test('should set [Tile.merged] to true', () {
        // ARRANGE
        int value = 2;
        var destination = Destination(
          x: 0,
          y: 0,
          hasMerged: true,
          hasMoved: true,
        );
        // ACT
        var tile = Tile.fromDestination(value, destination);
        // ASSERT
        expect(tile.merged, true);
      });
      test('should return doubled value', () {
        // ARRANGE
        int value = 2;
        var destination = Destination(
          x: 0,
          y: 0,
          hasMerged: true,
          hasMoved: true,
        );
        // ACT
        var tile = Tile.fromDestination(value, destination);
        // ASSERT
        expect(tile.value, value * 2);
      });
    });
  });

  group('clone', () {
    test('should return the same tile but different reference', () {
      // ARRANGE
      var currentTile = Tile(2, x: 0, y: 0);
      // ACT
      var actual = Tile.clone(currentTile);
      // ASSERT
      expect(actual, isNot(equals(currentTile)));
      expect(actual.value, currentTile.value);
      expect(actual.x, currentTile.x);
      expect(actual.y, currentTile.y);
      expect(actual.merged, currentTile.merged);
      expect(actual.isNew, currentTile.isNew);
    });
  });
}
