package components;

import spirit.components.NapeBody;
import spirit.core.Entity;
import spirit.graphics.Color;
import spirit.core.Scene;
import spirit.core.Component;

class BlockGroup extends Component {

  public var color(default, null): Color;

  public var body(default, null): NapeBody;

  public var awake(get, never): Bool;

  var box: Entity;

  var leftEye: Entity;

  var leftLid: Entity;

  var rightEye: Entity;

  var rightLid: Entity;

  var mouth: Entity;

  var sleeping: Sleeping;

  public function init(options: BoxGroupOptions): BlockGroup {
    box = options.box;
    leftEye = options.leftEye;
    leftLid = options.leftLid;
    rightEye = options.rightEye;
    rightLid = options.rightLid;
    mouth = options.mouth;
    color = options.color;
    body = options.body;

    sleeping = getComponent(Sleeping);

    return this;
  }

  public function remove(scene: Scene) {
    scene.removeEntity(leftEye);
    scene.removeEntity(leftLid);
    scene.removeEntity(rightEye);
    scene.removeEntity(rightLid);
    scene.removeEntity(mouth);
    scene.removeEntity(box);
  }

  inline function get_awake(): Bool {
    return sleeping.awake;
  }
}

typedef BoxGroupOptions = {
  var box: Entity;
  var leftEye: Entity;
  var leftLid: Entity;
  var rightEye: Entity;
  var rightLid: Entity;
  var mouth: Entity;
  var color: Color;
  var body: NapeBody;
}