/**
 * Created by User on 23/02/2017.
 */
package events {
import flash.events.Event;

public class MessageEvent extends Event {
    public static const ON_MESSAGE:String = "onMessage";
    public var params:Object;
    public function MessageEvent(type:String, _params:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.params = _params;
    }
}
}
