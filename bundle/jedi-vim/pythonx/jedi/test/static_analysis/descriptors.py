# classmethod
class TarFile():
    @classmethod
    def open(cls, name, **kwargs):
        return cls.taropen(name, **kwargs)

    @classmethod
    def taropen(cls, name, **kwargs):
        return name


# should just work
TarFile.open('hallo')
