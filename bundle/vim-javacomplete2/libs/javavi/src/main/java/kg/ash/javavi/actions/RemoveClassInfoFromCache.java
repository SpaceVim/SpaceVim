package kg.ash.javavi.actions;

import kg.ash.javavi.cache.Cache;

public class RemoveClassInfoFromCache extends ActionWithTarget {

    @Override
    public String perform(String[] args) {
        String target = parseTarget(args);
        if (Cache.getInstance().getClasses().containsKey(target)) {
            Cache.getInstance().getClasses().remove(target);
        }
        return "";
    }
}
