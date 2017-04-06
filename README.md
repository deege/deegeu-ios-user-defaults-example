# A Foolproof NSUserDefaults example in Swift 3.1 for iOS 10.3

The purpose of this repository is to supplement the video with code, and to provide a simple starting point to ad NSUserDefaults to your app.

The “A Foolproof NSUserDefaults example in Swift 2.0 for iOS 9” video demonstrates storing three different data types into the standard NSUserDefaults.

[![A Foolproof NSUserDefaults example in Swift 2.0 for iOS 9](https://img.youtube.com/vi/XD9LWJthqNE/0.jpg)](https://youtu.be/XD9LWJthqNE)

**The video uses Swift 3.1 and iOS 10.3 (updated 04-03-2017)**

This code has been updated since the making of the video. The code now requires two keys be set in the plist.info file:
    * NSPhotoLibraryUsageDescription
    * NSCameraUsageDescription
These can be set to any value.

Code in the function imagePickerController has also changed to find selected images from the editingInfo dictionary.

You can find more iOS videos on [the DeegeU channel](http://www.deegeu.com/subscribe)

## Getting started

The code is a self contained Swift project that can be loaded into XCode.

This code is written and compiled for Swift 3.1.

## Known issues
There are two issues when running the application.
1. objc[2962]: Class PLBuildVersion is implemented in both...
   This appears to be an issue on Apple's side. Neither library is controlled by this application. This only occurs in the emulator.
2. [Generic] Creating an image format with an unknown type is an error
   Unknown cause, but does not appear to affect the application functionality.

## Getting help

If you are having troubles getting the source code, please see [Getting the source code](http://www.deegeu.com/getting-the-source-code/) or the video [How to get code from GitHub](http://www.deegeu.com/videos/how-to-get-code-from-github/)  

## License

MIT: http://rem.mit-license.org

## Feedback

Any feedback is welcome. You can contact me at dj at deegeu.com, the [Facebook page](https://www.facebook.com/deegeu.programming.tutorials), the [Google+ page](https://plus.google.com/+Deegeu-programming-tutorials/posts) or on [DeegeU.com](http://www.deegeu.com).

## Contributions

If you wish to contribute to any issues you find in the source code, please issue a pull request.
