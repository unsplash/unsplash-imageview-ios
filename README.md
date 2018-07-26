# UnsplashImageView
A `UIImageView` subclass that displays a random photo from Unsplash.

## Installation
Download and copy `UnsplashImageView.swift` to your project. If you prefer, you can always use `git submodule`.

### Carthage
You don’t need a framework for a single file, move along.

### CocoaPods
Press Command+W right now.

## Usage
First, you need an Unsplash API access key. Visit our [Unsplash API page](https://unsplash.com/developers) to register as a developer for more information.

Once you have the access key, you can use `UnsplashImageView` either in Interface Builder or your code, like a UIImageView. To fetch a new photo, call the `fetchPhoto()` function.

### Settings
* `accessKey`: The API access key for your app.
* `query`: Search terms if you want to display photos around a specific topic.
* `imageURL`: This property is set once a photo is fetched and displayed, you can store this value somewhere, to re-use later.

## Notes
* Images are cached in memory (up to 50MB) and on disk (up to 100MB).
* If you want to display a placeholder image while it is fetching, set it on the `image` property, it will be replaced by the fetched photo.

## License

MIT License

Copyright (c) 2018 Unsplash Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.