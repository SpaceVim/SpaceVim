package kg.ash.javavi.actions;

import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.output.OutputPackageInfo;

public class GetPackageInfoAction extends ActionWithTarget {

    @Override
    public String perform(String[] args) {
        return new OutputPackageInfo(Cache.getInstance().getClassPackages()).get(parseTarget(args));
    }
}
