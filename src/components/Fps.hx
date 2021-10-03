package components;

import spirit.components.Text;
import spirit.core.Updatable;
import spirit.core.Component;

class Fps extends Component implements Updatable {

  var text: Text;

  var fps: Int;

  var times: Array<Float> = [];

  public function init(): Fps {
    text = getComponent(Text);

    return this;
  }

  public function update(dt: Float) {
    times.push(dt);
    if (times.length > 200) {
      times.shift();
    }
    var avg = 0.0;
    for (time in times) {
      avg += time;
    }
    avg /= times.length;
    fps = Math.floor(1.0 / avg);

    text.text = 'FPS: ${fps}';
  }

  override function get_requiredComponents(): Array<Class<Component>> {
    return [Text];
  }
}