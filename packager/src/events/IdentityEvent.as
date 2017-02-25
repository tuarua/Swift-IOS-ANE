/**
 * Created by User on 21/02/2017.
 */
package events {
import flash.events.Event;

public class IdentityEvent extends Event {
    public static const ON_IDENTITIES:String = "onIdentities";
    public var params:Object;

    public function IdentityEvent(type:String, _params:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.params = _params;
    }
}
}