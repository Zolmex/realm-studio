package common.util {
public class TimerRunner {

    private var timers:Vector.<TimedAction> = new Vector.<TimedAction>();

    public function push(act:TimedAction):void {
        this.timers.push(act);
    }

    public function update(deltaTime:int):void {
        for (var i:int = 0; i < this.timers.length; i++) {
            var act:TimedAction = this.timers[i];
            act.timeLeftMS -= deltaTime;
            if (act.timeLeftMS > 0){
                continue;
            }

            act.callback();
            this.timers.removeAt(i);
        }
    }
}
}
