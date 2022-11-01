package kg.ash.javavi.actions;

import kg.ash.javavi.Javavi;

public class GetAppVersion implements Action {

    @Override
    public String perform(String[] args) {
        return Javavi.VERSION;
    }
}
