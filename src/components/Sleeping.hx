package components;

import spirit.components.Sprite;
import spirit.components.NapeBody;
import spirit.core.Updatable;
import spirit.core.Component;

class Sleeping extends Component implements Updatable {

  public var awake(default, null) = false;

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
        leftEye.active = true;
        leftLid.active = true;
        leftLid.setFrame('eye_lid');
        rightEye.active = true;
        rightLid.active = true;
        rightLid.setFrame('eye_lid');
      } else {
        awake = true;
        leftEye.active = true;
        leftLid.active = false;
        rightEye.active = true;
        rightLid.active = false;
        mouth.setFrame('mouth_open');
      }
    } else {
      timeAwake = 0;
      timeStill += dt;
      if (awake) {
        if (timeStill > timeBeforesleep) {
          awake = false;
          leftEye.active = false;
          leftLid.active = true;
          leftLid.setFrame('eye_closed');
          rightEye.active = false;
          rightLid.active = true;
          rightLid.setFrame('eye_closed');
          mouth.setFrame('mouth_closed');
        } else if (timeStill > timeBeforeAlmostSleep) {
          leftEye.active = true;
          leftLid.active = true;
          leftLid.setFrame('eye_lid');
          rightEye.active = true;
          rightLid.active = true;
          rightLid.setFrame('eye_lid');
        }
      } else {
        if (timeStill < timeBeforeAlmostSleep) {
          leftEye.active = true;
          leftLid.active = true;
          leftLid.setFrame('eye_lid');
          rightEye.active = true;
          rightLid.active = true;
          rightLid.setFrame('eye_lid');
        } else {
          leftEye.active = false;
          leftLid.active = true;
          leftLid.setFrame('eye_closed');
          rightEye.active =false;
          rightLid.active = true;
          rightLid.setFrame('eye_closed');
          mouth.setFrame('mouth_closed');
        }
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