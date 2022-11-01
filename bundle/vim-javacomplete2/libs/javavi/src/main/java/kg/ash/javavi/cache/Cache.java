package kg.ash.javavi.cache;

import kg.ash.javavi.Javavi;
import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.Logger;
import kg.ash.javavi.clazz.SourceClass;
import kg.ash.javavi.searchers.JavaClassMap;
import kg.ash.javavi.searchers.PackagesLoader;

import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;

public class Cache {

    public static final Logger logger = LogManager.getLogger();
    public static final String PACKAGES_EMPTY_ERROR
        = "message: packages still empty, try later. indexing...";

    private CacheSerializator serializator = new CacheSerializator();
    private HashMap<String, JavaClassMap> classPackages = new HashMap<>();
    private HashMap<String, SourceClass> classes = new HashMap<>();
    private Timer autosaveCacheTimer = new Timer();
    private boolean collectIsRunning = false;
    private int autosavePeriod = 60;
    private int cacheCode;

    private static Cache instance;

    public static Cache getInstance() {
        if (instance == null) {
            instance = new Cache();
        }
        return instance;
    }

    public synchronized void collectPackages() {
        if (collectIsRunning) {
            return;
        }

        collectIsRunning = true;
        new Thread(() -> {
            logger.info("start collecting cache");
            loadCache();

            if (classPackages.isEmpty()) {
                logger.info("collecting empty cache");

                HashMap<String, JavaClassMap> classPackagesTemp = new HashMap<>();
                new PackagesLoader(Javavi.system.get("sources")).collectPackages(classPackagesTemp);
                classPackages.putAll(classPackagesTemp);

                saveCache();
            }

            cacheCode = getClassPackages().hashCode();
            collectIsRunning = false;

            autosaveCacheTimer.schedule(new AutosaveTask(this), autosavePeriod * 1000);
        }).start();
    }

    @SuppressWarnings("unchecked")
    public void loadCache() {
        Object o = serializator.loadCache("class_packages");
        if (o != null) {
            try {
                classPackages = (HashMap<String, JavaClassMap>) o;
            } catch (ClassCastException e) {
                logger.warn("Couldn't load cache");
            }
        }
    }

    public void saveCache() {
        serializator.saveCache("class_packages", classPackages);
    }

    public HashMap<String, JavaClassMap> getClassPackages() {
        if (classPackages.isEmpty()) {
            collectPackages();
        }
        return classPackages;
    }

    public HashMap<String, SourceClass> getClasses() {
        return classes;
    }

    class AutosaveTask extends TimerTask {
        private final Cache cache;

        public AutosaveTask(Cache cache) {
            this.cache = cache;
        }

        public void run() {
            int newCode = cache.getClassPackages().hashCode();
            if (newCode != cache.cacheCode) {
                logger.info("autosave cache: {} != {}", newCode, cache.cacheCode);
                cache.saveCache();
                cache.cacheCode = cache.getClassPackages().hashCode();
            }
            cache.autosaveCacheTimer.schedule(new AutosaveTask(cache), cache.autosavePeriod * 1000);
        }
    }
}
