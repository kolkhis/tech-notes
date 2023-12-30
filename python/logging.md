


```python

BASIC_FORMAT = "%(levelname)s:%(name)s:%(message)s"

_STYLES = {
    '%': (PercentStyle, BASIC_FORMAT),
    '{': (StrFormatStyle, '{levelname}:{name}:{message}'),
    '$': (StringTemplateStyle, '${levelname}:${name}:${message}'),
}

class Formatter(object):
    """
        Formatter instances are used to convert a LogRecord to text.

        Formatters need to know how a LogRecord is constructed. They are
        responsible for converting a LogRecord to (usually) a string which can
        be interpreted by either a human or an external system.

        The base Formatter allows a formatting string to be specified.
        If none is supplied, the style-dependent default value,
        "%(message)s", "{message}", or "${message}", is used.

        Currently, the useful attributes in a LogRecord are described by:

    %(name)s            Name of the logger (logging channel)
    %(levelno)s         Numeric logging level for the message (DEBUG, INFO,
                        WARNING, ERROR, CRITICAL)
    %(levelname)s       Text logging level for the message ("DEBUG", "INFO",
                        "WARNING", "ERROR", "CRITICAL")
    %(pathname)s        Full pathname of the source file where the logging
                        call was issued (if available)
    %(filename)s        Filename portion of pathname
    %(module)s          Module (name portion of filename)
    %(lineno)d          Source line number where the logging call was issued
                        (if available)
    %(funcName)s        Function name
    %(created)f         Time when the LogRecord was created (time.time()
                        return value)
    %(asctime)s         Textual time when the LogRecord was created
    %(msecs)d           Millisecond portion of the creation time
    %(relativeCreated)d Time in milliseconds when the LogRecord was created,
                        relative to the time the logging module was loaded
                        (typically at application startup time)
    %(thread)d          Thread ID (if available)
    %(threadName)s      Thread name (if available)
    %(process)d         Process ID (if available)
    %(message)s         The result of record.getMessage(), computed just as
                        the record is emitted
    """

```



## Formatting
The `format` parameter (`logging.basicConfig(format='')`) is a string which defines how a LogRecord is converted to text.

It has default variable names available for use in string formats.
Below is a list of the C-style `printf` formatting directives that can be used in `format`.

| Directive | Meaning
|-|-
| `%(name)s` | Name of the logger (logging channel)
| `%(levelno)s` | Numeric logging level for the message (DEBUG, INFO, WARNING, ERROR, CRITICAL)
| `%(levelname)s` | Text logging level for the message (DEBUG, INFO, WARNING, ERROR, CRITICAL)
| `%(pathname)s` | Full pathname of the source file where the logging call was issued (if available)
| `%(filename)s` | Filename portion of pathname
| `%(module)s` | Module (name portion of filename)
| `%(lineno)d` | Source line number where the logging call was issued (if available)
| `%(funcName)s` | Function name
| `%(created)f` | Time when the LogRecord was created (`time.time()` return value)
| `%(asctime)s` | Textual time when the LogRecord was created
| `%(msecs)d` | Millisecond portion of the creation time
| `%(relativeCreated)d` | Time in milliseconds when the LogRecord was created, relative to the time the logging module was loaded (typically at application startup time)
| `%(thread)d` | Thread ID (if available)
| `%(threadName)s` | Thread name (if available)
| `%(process)d` | Process ID (if available)
| `%(message)s` | The result of `record.getMessage()`, computed just as the record is emitted

An example of a format string:
```python
import logging
logging.basicConfig(format="%(asctime)s - %(name)s - %(levelname)s - %(message)s")
```




