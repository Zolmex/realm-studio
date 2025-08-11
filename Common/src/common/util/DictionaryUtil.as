package common.util {
import flash.utils.Dictionary;

public class DictionaryUtil {

    public static function length(myDictionary:Dictionary):int {
        var n:int = 0;
        for (var key:* in myDictionary) {
            n++;
        }
        return n;
    }
}
}
