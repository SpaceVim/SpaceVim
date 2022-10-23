def set_debug(logger, path):
    from logging import FileHandler, Formatter, DEBUG
    hdlr = FileHandler(path)
    logger.addHandler(hdlr)
    datefmt = '%Y/%m/%d %H:%M:%S'
    fmt = Formatter(
        "%(levelname)s %(asctime)s %(message)s", datefmt=datefmt)
    hdlr.setFormatter(fmt)
    logger.setLevel(DEBUG)
