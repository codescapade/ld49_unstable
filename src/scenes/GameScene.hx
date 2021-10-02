package scenes;

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

class GameScene extends Scene {

  var boxBody: NapeBody;

  public override function init() {
    trace('game scene init');
    Game.debugDraw = true;
    var physics = addSystem(NapePhysicsSystem).init({ gravity: { x: 0, y: 400 } });
    addSystem(UpdateSystem).init();
    addSystem(RenderSystem).init();

    var cam = addEntity(Entity);
    cam.addComponent(Transform).init();
    cam.addComponent(Camera).init();

    var bottomE = addEntity(Entity);
    bottomE.addComponent(Transform).init({ x: display.viewCenterX, y: display.viewHeight - 10 });
    var body = bottomE.addComponent(NapeBody).init({type: BodyType.STATIC });
    body.createRectBody(800, 20);

    var be = addEntity(Entity);
    be.addComponent(Transform).init({ x: display.viewCenterX + 35, y: 500 });
    var bx = be.addComponent(NapeBody).init();
    bx.createRectBody(60, 60);

    var boxE = addEntity(Entity);
    boxE.addComponent(Transform).init({ x: display.viewCenterX, y: display.viewCenterY });
    boxBody = boxE.addComponent(NapeBody).init();
    boxBody.createRectBody(50, 50);
  }


  public override function update(dt: Float) {
    super.update(dt);

    if (boxBody.body.velocity.length > 10) {
      trace('moving');
    }
  }
}