package scenes;

import spirit.graphics.texturepacker.SpriteSheet;
import spirit.graphics.Image;
import spirit.components.Sprite;
import spirit.graphics.Color;
import components.Sleeping;
import nape.geom.Vec2;
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
  var bodies: Array<NapeBody> = [];

  var wallColor = Color.fromValues(100, 80, 160, 255);

  var boxImage: Image;

  var sheet: SpriteSheet;

  var blue = Color.fromValues(50, 50, 220, 255);

  public override function init() {
    trace('game scene init');
    // Game.debugDraw = true;
    var physics = addSystem(NapePhysicsSystem).init({ gravity: { x: 0, y: 400 } });
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
    floor.addComponent(BoxShape).init({ width: 800, height: 20, filled: true, fillColor: wallColor });

    var leftWall = addEntity(Entity);
    leftWall.addComponent(Transform).init({ x: 10, y: display.viewCenterY });
    leftWall.addComponent(NapeBody)
      .init({ type: BodyType.STATIC })
      .createRectBody(20, 1200);
    leftWall.addComponent(BoxShape).init({ width: 20, height: 1200, filled: true, fillColor: wallColor});

    var rightWall = addEntity(Entity);
    rightWall.addComponent(Transform).init({ x: 790, y: display.viewCenterY });
    rightWall.addComponent(NapeBody)
      .init({ type: BodyType.STATIC })
      .createRectBody(20, 1200);
    rightWall.addComponent(BoxShape).init({ width: 20, height: 1200, filled: true, fillColor: wallColor});


    var fpsEntity = addEntity(Entity);
    fpsEntity.addComponent(Transform).init({ x: 10, y: 30, zIndex: 1 });
    fpsEntity.addComponent(Text).init({ font: font, text: 'FPS: 0', anchorX: 0, anchorY: 0 });
    fpsEntity.addComponent(Fps).init();
    
    events.on(MouseEvent.MOUSE_DOWN, mouseDown);

    createStartBlocks(28);
  }

  public override function cleanup() {
    super.cleanup();
    events.off(MouseEvent.MOUSE_DOWN, mouseDown);
  }

  public override function update(dt: Float) {
    super.update(dt);
  }

  function mouseDown(event: MouseEvent) {
    for (body in bodies) {
      if (body.containsPoint(event.x, event.y)) {
        removeEntity(body.userData.leftEye);
        removeEntity(body.userData.leftLid);
        removeEntity(body.userData.rightEye);
        removeEntity(body.userData.rightLid);
        removeEntity(body.userData.mouth);
        removeEntity(body.userData.entity);
        bodies.remove(body);
        return;
      }
    }

    createBlock(event.x, event.y);
  }

  function createBlock(x: Float, y: Float) {
    var boxE = addEntity(Entity);
    var parent = boxE.addComponent(Transform).init({ x: x, y: y });
    // var parent = boxE.addComponent(Transform).init({ x: display.viewCenterX, y: display.viewCenterY });
    var boxBody = boxE.addComponent(NapeBody).init();
    boxBody.userData.entity = boxE;
    var width = 60;
    var height = 60;
    boxBody.createRectBody(width, height);
    bodies.push(boxBody);
    boxE.addComponent(Sprite).init({ sheet: sheet, frameName: 'block', color: blue });

    var leftEye = addEntity(Entity);
    leftEye.addComponent(Transform).init({ x: -15, y: -5, parent: parent, zIndex: 1 });
    var leftEyeSprite = leftEye.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_middle' });

    var leftLid = addEntity(Entity);
    leftLid.addComponent(Transform).init({ x: -15, y: -5, parent: parent, zIndex: 2 });
    var leftLidSprite = leftLid.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_lid', color: blue });
    
    var rightEye = addEntity(Entity);
    rightEye.addComponent(Transform).init({ x: 15, y: -5, parent: parent, zIndex: 1 });
    var rightEyeSprite = rightEye.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_middle' });

    var rightLid = addEntity(Entity);
    rightLid.addComponent(Transform).init({ x: 15, y: -5, parent: parent, zIndex: 2 });
    var rightLidSprite = rightLid.addComponent(Sprite).init({ sheet: sheet, frameName: 'eye_lid', color: blue });

    var mouth = addEntity(Entity);
    mouth.addComponent(Transform).init({ y: 20, parent: parent, zIndex: 1 });
    var mouthSprite = mouth.addComponent(Sprite).init({ sheet: sheet, frameName: 'mouth_closed' });

    boxE.addComponent(Sleeping).init({leftEye: leftEyeSprite, leftLid: leftLidSprite, rightEye: rightEyeSprite,
        rightLid: rightLidSprite, mouth: mouthSprite });

    boxBody.userData.leftEye = leftEye;
    boxBody.userData.leftLid = leftLid;
    boxBody.userData.rightEye = rightEye;
    boxBody.userData.rightLid = rightLid;
    boxBody.userData.mouth = mouth;
  }

  function createStartBlocks(nr: Int) {
    for (i in 0...nr) {
      var x = random.int(100, 700);
      var y = random.int(-80, -50);
      createBlock(x, y);
    }
  }
}