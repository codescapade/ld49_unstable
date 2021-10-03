package scenes;

import components.BlockGroup;
import spirit.graphics.texturepacker.SpriteSheet;
import spirit.graphics.Image;
import spirit.components.Sprite;
import spirit.graphics.Color;
import components.Sleeping;
import spirit.components.Text;
import spirit.components.BoxShape;
import spirit.events.input.MouseEvent;
import spirit.components.Camera;
import spirit.systems.UpdateSystem;
import spirit.systems.RenderSystem;
import nape.phys.BodyType;
import spirit.components.NapeBody;
import spirit.core.Game;
import spirit.components.Transform;
import spirit.core.Entity;
import spirit.systems.NapePhysicsSystem;
import spirit.core.Scene;
import components.Fps;

// abudant-music

class GameScene extends Scene {
  var blocks: Array<BlockGroup> = [];

  var wallColor = Color.fromValues(100, 80, 160, 255);

  var boxImage: Image;

  var sheet: SpriteSheet;

  var blue = Color.fromValues(77, 61, 210, 255);

  var orange = Color.fromValues(234, 136, 45, 255);

  var red = Color.fromValues(210, 61, 209, 255);

  var green = Color.fromValues(61, 210, 118, 255);

  var colors: Array<Color>; 

  var nextBlockSprite: Sprite;

  var started = false;

  var barsize = 100.0;

  var barText: Text;

  var allFalling = false;

  public override function init() {
    trace('game scene init');
    // Game.debugDraw = true;
    colors = [blue, orange, red, green];

    addSystem(NapePhysicsSystem).init({ gravity: { x: 0, y: 400 } });
    addSystem(UpdateSystem).init();
    addSystem(RenderSystem).init();

    var font = assets.addBitmapFont('testFont', 'assets/fonts/test.png', 'assets/fonts/test.fnt');
    boxImage = assets.getImage('assets/test.png');
    sheet = assets.addSpriteSheet('sheet', 'assets/sprites.png', 'assets/sprites.json');

    var cam = addEntity(Entity);
    cam.addComponent(Transform).init();
    cam.addComponent(Camera).init();

    var floor = addEntity(Entity);
    floor.addComponent(Transform).init({ x: display.viewCenterX, y: display.viewHeight - 10 });
    floor.addComponent(NapeBody)
      .init({ type: BodyType.STATIC })
      .createRectBody(800, 20);
    floor.addComponent(BoxShape).init({ width: 800, height: 20, filled: true, fillColor: wallColor, hasStroke: false });

    var leftWall = addEntity(Entity);
    leftWall.addComponent(Transform).init({ x: 10, y: display.viewCenterY });
    leftWall.addComponent(NapeBody)
      .init({ type: BodyType.STATIC })
      .createRectBody(20, 1200);
    leftWall.addComponent(BoxShape).init({ width: 20, height: 1200, filled: true, fillColor: wallColor, hasStroke: false });

    var rightWall = addEntity(Entity);
    rightWall.addComponent(Transform).init({ x: 790, y: display.viewCenterY });
    rightWall.addComponent(NapeBody)
      .init({ type: BodyType.STATIC })
      .createRectBody(20, 1200);
    rightWall.addComponent(BoxShape).init({ width: 20, height: 1200, filled: true, fillColor: wallColor, hasStroke: false });

    var fpsEntity = addEntity(Entity);
    fpsEntity.addComponent(Transform).init({ x: 10, y: 30, zIndex: 1 });
    fpsEntity.addComponent(Text).init({ font: font, text: 'FPS: 0', anchorX: 0, anchorY: 0 });
    fpsEntity.addComponent(Fps).init();

    var nextBlock = addEntity(Entity);
    var parent = nextBlock.addComponent(Transform).init({ x: display.viewCenterX, y: 50, zIndex: 10 });
    nextBlockSprite = nextBlock.addComponent(Sprite).init({ sheet: sheet, frameName: 'block' });
    
    var leftEye = addEntity(Entity);
    leftEye.addComponent(Transform).init({ x: -15, y: -5, parent: parent, zIndex: 12 });
    leftEye.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_middle' });

    var rightEye = addEntity(Entity);
    rightEye.addComponent(Transform).init({ x: 15, y: -5, parent: parent, zIndex: 12 });
    rightEye.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_middle' });

    var mouth = addEntity(Entity);
    mouth.addComponent(Transform).init({ y: 20, parent: parent, zIndex: 12 });
    mouth.addComponent(Sprite).init({ sheet: sheet, frameName: 'mouth_closed' });


    var barE = addEntity(Entity);
    barE.addComponent(Transform).init({ x: 750, y: 30, zIndex: 10 });
    barText = barE.addComponent(Text).init({ font: font, text: '100' });

    events.on(MouseEvent.MOUSE_DOWN, mouseDown);

    timers.create(2, () -> {
      allFalling = true;
      setNextColor();
    }, 0, true);

    createStartBlocks(28);
  }

  public override function cleanup() {
    super.cleanup();
    events.off(MouseEvent.MOUSE_DOWN, mouseDown);
  }

  public override function update(dt: Float) {
    super.update(dt);

    if (!allFalling) {
      return;
    }

    if (!started) {
      for (block in blocks) {
        if (block.awake) {
          return;
        }
      }
      started = true;
    }

    var someAwake = false;
    for (block in blocks) {
      if (block.awake) {
        someAwake = true;
        break;
      }
    }

    if (someAwake) {
      barsize -= dt * 5; 
      if (barsize < 0) {
        barText.text = 'Time is up!';
      } else {
        barText.text = '${Math.round(barsize)}';
      }
    }
  }

  function setNextColor() {
    if (blocks.length == 0) {
      return;
    }

    var block = blocks[random.int(0, blocks.length - 1)];
    nextBlockSprite.color = block.color;
  }

  function mouseDown(event: MouseEvent) {
    if (!started) {
      return;
    }

    for (block in blocks) {
      if (block.color == nextBlockSprite.color && block.body.containsPoint(event.x, event.y)) {
        block.remove(this);
        blocks.remove(block);
        setNextColor();
        return;
      }
    }
  }

  function createBlock(x: Float, y: Float) {
    var boxE = addEntity(Entity);
    var parent = boxE.addComponent(Transform).init({ x: x, y: y });

    var color = colors[random.int(0, colors.length - 1)];

    var boxBody = boxE.addComponent(NapeBody).init();
    boxBody.userData.entity = boxE;
    var width = 60;
    var height = 60;
    boxBody.createRectBody(width, height);
    boxE.addComponent(Sprite).init({ sheet: sheet, frameName: 'block', color: color });

    var leftEye = addEntity(Entity);
    leftEye.addComponent(Transform).init({ x: -15, y: -5, parent: parent, zIndex: 1 });
    var leftEyeSprite = leftEye.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_middle' });

    var leftLid = addEntity(Entity);
    leftLid.addComponent(Transform).init({ x: -15, y: -5, parent: parent, zIndex: 2 });
    var leftLidSprite = leftLid.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_lid', color: color });
    
    var rightEye = addEntity(Entity);
    rightEye.addComponent(Transform).init({ x: 15, y: -5, parent: parent, zIndex: 1 });
    var rightEyeSprite = rightEye.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_middle' });

    var rightLid = addEntity(Entity);
    rightLid.addComponent(Transform).init({ x: 15, y: -5, parent: parent, zIndex: 2 });
    var rightLidSprite = rightLid.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_lid', color: color });

    var mouth = addEntity(Entity);
    mouth.addComponent(Transform).init({ y: 20, parent: parent, zIndex: 1 });
    var mouthSprite = mouth.addComponent(Sprite).init({ sheet: sheet, frameName: 'mouth_closed' });

    boxE.addComponent(Sleeping).init({leftEye: leftEyeSprite, leftLid: leftLidSprite, rightEye: rightEyeSprite,
        rightLid: rightLidSprite, mouth: mouthSprite });
    
    var group = boxE.addComponent(BlockGroup).init({ box: boxE, leftEye: leftEye, leftLid: leftLid, rightEye: rightEye,
        rightLid: rightLid, mouth: mouth, color: color, body: boxBody });
    
    blocks.push(group);
  }

  function createStartBlocks(nr: Int) {
    for (i in 0...nr) {
      var x = random.int(100, 700);
      var y = random.int(-80, -50);
      createBlock(x, y);
    }
  }
}