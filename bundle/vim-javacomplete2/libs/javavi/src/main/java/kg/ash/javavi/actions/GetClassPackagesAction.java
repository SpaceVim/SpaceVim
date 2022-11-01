package kg.ash.javavi.actions;

import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.output.OutputClassPackages;

public class GetClassPackagesAction extends ActionWithTarget {

    @Override
    public String perform(String[] args) {
        return new OutputClassPackages(Cache.getInstance().getClassPackages()).get(
            parseTarget(args));
    }
}
