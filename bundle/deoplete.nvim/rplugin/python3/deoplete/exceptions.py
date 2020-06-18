class SourceInitError(Exception):
    """Error during source initialization.

    This can be used to have a clearer message, where not traceback gets
    displayed.
    """
