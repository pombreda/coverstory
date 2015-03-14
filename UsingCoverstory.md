# Introduction #

CoverStory is a GUI tool for analyzing which lines of your code have actually been executed when you run you test your code. It requires a little set up to use effectively, you must make some target changes in your Xcode project.

# Project Settings #

## Xcode 6 with  iOS 8 Simulator ##
Same issues as Xcode 5/iOS 7 except Apple has decided to deprecate the XCTestObserver class which says that the way we are hooking the end of test runs is on its way out unless we can find a replacement.

We've filed a Radar with Apple asking for it back/a replacement. Feel free to do the same :)

## Xcode 5 with LLVM Compiler iOS 7 Simulator ##

Code coverage doesn't work well with iOS 7 because iOS 7 does not call any code at the "end" of an app. iOS7 does not:
  1. allow you to register functions with atexit
  1. run any functions marked with the attribute((destructor))
  1. run any C++ destructors for global objects
This seems to also kill off the ability for gcov to call gcov\_flush when the tests are done so it can write out the `*`.gcda files. Note that gcov\_flush must be called in the execution unit that you want the gcda files written out for (i.e. you can't link it in the test bundle, you need to link it in the app bundle).

Assuming you have an app with a test bundle that you want to have coverage run on:
  1. Turn on "Generate Test Coverage Files" (-ftest-coverage) in your build settings for the app.
  1. Turn on "Instrument Program Flow" (-fprofile-arcs) in your build settings for the app.
  1. Add GTMCodeCoverageApp.m/.h to your app sources from [here](https://code.google.com/p/google-toolbox-for-mac/source/browse/#svn%2Ftrunk%2FUnitTesting).
  1. Add GTMCodeCoverageTestsST.m or GTMCodeCoverageTestsXC.m (depending on whether you are using SenTests or XCTests) from [here](https://code.google.com/p/google-toolbox-for-mac/source/browse/#svn%2Ftrunk%2FUnitTesting) to your test sources.

You should be able to build and run your tests and generate coverage data (gcda and gcno files).

If you use the iOS 6.x Simulators, cover seems to work as it did before.

## Xcode 5 with LLVM Compiler Mac SDK ##

Should work fine.

  1. Turn on "Generate Test Coverage Files" (-ftest-coverage) in your build settings for the app.
  1. Turn on "Instrument Program Flow" (-fprofile-arcs) in your build settings for the app.

## Xcode 4.6.3 with LLVM Compiler ##

Code coverage is working on iOS. See the instructions for Xcode 4.2 below.

## Xcode 4.3 with LLVM Compiler ##

Unfortunately it appears that code coverage is broken again for iOS using llvm. libprofile\_rt has not been compiled with i386, and doesn't even appear in the iOS SDK.

## Xcode 4.2 with LLVM Compiler ##

With Xcode 4.2 (4C139 aka iOS 5 beta 4) code coverage appears to be working with LLVM. To get it working you need to do the following:

  1. Add `-fprofile-arcs` and `-ftest-coverage` to `Other C Flags`
  1. Link `/Developer/usr/lib/libprofile_rt.dylib` into your app
  1. Build and run

and that should be it. It appears to work with precompiled headers on or off. Note that the current version of CoverStory will give you some warnings about the .gcda and .gcno version numbers, but you can ignore them. (http://llvm.org/bugs/show_bug.cgi?id=10502 is one of the issues and http://openradar.appspot.com/radar?id=1276409 is the other)

Turning on the `Generate Profiling Code` doesn't appear to function at this time. Feel free to file your own Radars and reference 9596252.

Note that the .gcno and .gcda files will be located beside your object files which by default in Xcode 4 are created in a subpath of `~/Library/Developer/Xcode/DerivedData/`

Also, make sure that your app "quits" correctly. For iOS apps this may require adding "UIApplicationExitsOnSuspend = NO" (aka Application does not run in background) to your info.plist

## Xcode 3 ##

![http://coverstory.googlecode.com/svn/site/images/settings.png](http://coverstory.googlecode.com/svn/site/images/settings.png)

To work with CoverStory, first you need to set up your target to work with gcov. This requires turning on "Instrument Program Flow", "Generate Test Coverage Files" and linking with the gcov library.

The [EnableGCov.scpt](http://coverstory.googlecode.com/svn/trunk/Tools/EnableGCov.scpt) will do this for the current configuration of the current target of the frontmost project.

Then build and run your project and exercise the code you wish to profile.

Once you are done you should find a collection of `*.gcda` and `*.gcno` files created inside of your build directory. For a project name TestProj and a configuration named TestConfig and a target named TestTarget built for i386, you will find them at:

```
TestProj.xcodeproj
build/TestProj.build/TestConfig/TestTarget.build/Objects-normal/i386
```

assuming you are using standard build settings.

You then need to open these files with CoverStory. You can open individual files to see how the coverage or you can open the the whole build folder with CoverStory and it will show all coverage data, merging i386 and ppc data runs.

# Export To HTML #
The "Export To HTML" option in the file menu allows you to export your CoverStory data as HTML. You can do extensive customization on the HTML we produce by replacing the default coverstory.css and coverstory.js files with your own css and js post export. Take a look at the coverstory.js file for an example of adding an element to the default HTML we spit out.

# AppleScript #
CoverStory now has extensive AppleScript support. One interesting issue is due to [radar 6808327](http://openradar.appspot.com/6808327) you should always call "activate" before calling "open" or else you may run into problems with the files not completely opening before the next step in the script is performed.
```
tell application "CoverStory"
  activate
  set a to open "foo/bar"
  tell a
    export to html
  end
end
```

# Trouble Shooting #
If you are having problems with coverstory and/or code coverage in general on the Mac, please check out the other wiki pages which list solutions to several common problems.