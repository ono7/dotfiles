# For gcc and Clang users

```markdown
Add -ggdb to the command line for debug builds and -O2 -DNDEBUG for release builds. Use the debug build options for
now.

For GCC and Clang, the -O# option is used to control optimization settings. The most common options are as follows:

-O0 is the recommended optimization level for debug builds, as it disables optimization. This is the default setting.

-O2 is the recommended optimization level for release builds, as it applies optimizations that should be beneficial for all programs.

-O3 adds additional optimizations that may or may not perform better than -O2 depending on the specific program. Once your program is written, you can try compiling your release build with -O3 instead of -O2 and measure to see which is faster.
See https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html for information on optimization options.
```
