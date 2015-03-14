# Introduction #

Sometimes certain sections of code are not feasible to test.  To name a few, this includes:
  * Code that's platform-specific, thus not testable in the environment where the coverage data is collected.
  * Code that does sanity checks and is expected to be not covered.
  * Code that's not feasible or too difficult to test.  It's not cost-effective to test this portion of code for whatever reason.

To help you with these sections, CoverStory supports some special markings to tell it to ignore that code. These NF (non-feasible) markings should be used responsibly.  They're added to help you eliminate _noise_ in the data. You should aim for 100% coverage if you use this marking in your code.


# Details #

To mark a single line as non-feasible, add a `// COV_NF_LINE` to the end of the line. To mark a block as non-feasible, surround it with `// COV_NF_START` and `// COV_NF_END`.


Some code samples:

  * Line-based markers:
> It excludes a particular line from coverage percentage calculation.  It takes effect only when the given line is instrumented.

```
   if (all_hell_breaks_loose) {
      NSLog(@"The sky is falling! The sky is falling!");      // COV_NF_LINE
   }
```

  * Range-based markers:
> It excludes the section of code falling into the range of the marker.  The markers are inclusive, but don't nest.

```
   #ifdef OS_WINDOWS   // COV_NF_START
     do task a;
     ...
     do task z;
   #endif              // COV_NF_END
```

# Xcode Script #
There is a python script for the Xcode script menu named [MarkAsCodeCoverageNonFeasible](http://code.google.com/p/coverstory/source/browse/trunk/Tools/MarkAsCodeCoverageNonFeasible.py) which greatly simplifies marking chunks of code as non-feasible for code coverage. Read the script for installation instructions.