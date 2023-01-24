import 'package:dance_partner_finder/game_state_repository/game_event.dart';
import 'package:dance_partner_finder/game_state_repository/game_event_repository.dart';
import 'package:dance_partner_finder/game_state_repository/movable.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'my_green_girl.dart';

class JustFrontendGame extends FlameGame with HasDraggables, HasTappables {
  late final JoystickComponent joystickComponent;
  late final MyGreenGirl myGreenGirl;
  late final HudButtonComponent shapeButton;
  late final TextComponent playerLifeIndicator;
  final gameEventRepository = GameEventRepository("mm7amini@gmail.com");

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = false;

    camera.viewport = FixedResolutionViewport(Vector2(1366, 768));
    var right = size.x + 100;
    var bottom = size.y;
    camera.worldBounds = Rect.fromLTRB(0, 0, right, bottom);

    SpriteComponent background = SpriteComponent()
      ..sprite = await loadSprite("background.jpeg")
      ..position = Vector2(5, 5)
      ..size = Vector2(right - 10, bottom - 10)
      ..anchor = Anchor.topLeft;
    add(background);

    final knobPaint = BasicPalette.red.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystickComponent = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 70, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 50, bottom: 100),
    )..positionType = PositionType.viewport;
    await add(joystickComponent);

    myGreenGirl = MyGreenGirl(size / 2, "ninja");
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (!joystickComponent.delta.isZero()) {
      var event = JoystickMovedEvent(
          joystickComponent.direction, joystickComponent.relativeDelta);
      gameEventRepository.sendJoystickEvent(event);
    }

    if (gameEventRepository.movables.isNotEmpty) {
      await notifyGameState(gameEventRepository.movables.removeFirst());
    }
  }

  Future<void> notifyGameState(Movable ninja) async {
    print("coming ninja $ninja");
    if (myGreenGirl.parent == null) {
      await add(myGreenGirl);
      camera.followComponent(myGreenGirl);
      print("ninja added");
    }
    myGreenGirl.handleMovable(ninja);
  }
}
