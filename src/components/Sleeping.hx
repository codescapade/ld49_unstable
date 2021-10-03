package components;

import spirit.components.Sprite;
import spirit.graphics.Color;
import spirit.components.BoxShape;
import spirit.components.NapeBody;
import spirit.core.Updatable;
import spirit.core.Component;

class Sleeping extends Component implements Updatable {

  var body: NapeBody;

  var timeAwake = 0.0;

  var timeStill = 0.0;

  var timeBeforeFullAwake = 0.5;

  var timeBeforesleep = 1.0;

  var timeBeforeAlmostSleep = 0.5;

  var leftEye: Sprite;

  var leftLid: Sprite;

  var rightEye: Sprite;

  var rightLid: Sprite;

  var mouth: Sprite;

  var awake: Bool;

  public function init(options: SleepingOptions) {
    body = getComponent(NapeBody);

    leftEye = options.leftEye;
    leftLid = options.leftLid;
    rightEye = options.rightEye;
    rightLid = options.rightLid;
    mouth = options.mouth;
  }

  public function update(dt: Float) {
    if (Math.abs(body.body.angularVel) > 5 || body.body.velocity.length > 5) {
      timeStill = 0;
      timeAwake += dt;
      if (!awake && timeAwake < timeBeforeFullAwake) {
        leftLid.active = true;
        leftLid.setFrame('eye_lid');
        rightLid.active = true;
        rightLid.setFrame('eye_lid');
      } else {
        awake = true;
        leftLid.active = false;
        rightLid.active = false;
        mouth.setFrame('mouth_open');
      }
    } else {
      timeAwake = 0;
      timeStill += dt;
      if (awake) {
        if (timeStill > timeBeforesleep) {
          awake = false;
          leftLid.active = true;
          leftLid.setFrame('eye_closed');
          rightLid.active = true;
          rightLid.setFrame('eye_closed');
          mouth.setFrame('mouth_closed');
        } else if (timeStill > timeBeforeAlmostSleep) {
          leftLid.active = true;
          leftLid.setFrame('eye_lid');
          rightLid.active = true;
          rightLid.setFrame('eye_lid');
        }
      } else {
        leftLid.active = true;
        leftLid.setFrame('eye_closed');
        rightLid.active = true;
        rightLid.setFrame('eye_closed');
        mouth.setFrame('mouth_closed');
      }
    }
  }
}

typedef SleepingOptions = {
  var leftEye: Sprite;
  var leftLid: Sprite;
  var rightEye: Sprite;
  var rightLid: Sprite;
  var mouth: Sprite;
}