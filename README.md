# PGNotificationView

[![CI Status](http://img.shields.io/travis/ipagong/PGNotificationView.svg?style=flat)](https://travis-ci.org/ipagong/PGNotificationView)
[![Version](https://img.shields.io/cocoapods/v/PGNotificationView.svg?style=flat)](http://cocoapods.org/pods/PGNotificationView)
[![License](https://img.shields.io/cocoapods/l/PGNotificationView.svg?style=flat)](http://cocoapods.org/pods/PGNotificationView)
[![Platform](https://img.shields.io/cocoapods/p/PGNotificationView.svg?style=flat)](http://cocoapods.org/pods/PGNotificationView)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

appetize.io demo : [\[ here \]](https://appetize.io/embed/1w9tw6uvztqueh3m2ykk65xr4c?device=iphone5s&scale=75&orientation=portrait&osVersion=9.3)


It's notification view creator (uiwindow).

just send your custom view and then some setups, and call show().

it's' very comfortable notificationview.


### 1. create > show

```swift

NotificationView.create(YourNotiView("hello")).show()
```

### 2. create > setup(duration) > show

```swift

NotificationView.create(YourNotiView("hello")).setupDuration(present: 0.3, dismiss: 0.3, expose: 3).show()
```

### 3. create > setup(touch) > show

```swift

NotificationView.create(YourNotiView("hello")).whenTouch { view in
    print("third notification touched.")
}.show()
```

### 4. create > setup(completion) > show
```swift

NotificationView.create(YourNotiView("hello")).whenCompletion { completed in
    print("hide completion.")
}.show()
```

### 5. create > combine setups > show
```swift

// you can choose setup methods.
NotificationView.create(YourNotiView("hello"))
  .setupDuration(present: 0.3, dismiss: 0.3, expose: 3)
  .whenTouch { view in
      print("third notification touched.")
  }.whenCompletion { completed in
      print("hide completion.")
  }.show()

```

### 6. find old notification view that not deinit yet.
```swift

//find last.
NotificationView.find(YourNotiView.self)?.hide()

//find all type.
NotificationView.findAll(YourNotiView.self)?.forEach({ notiview in
    // do something.
})
```


## Requirements

- above ios 8.0
- swift 3.0
- with cocoapods

## Installation

 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PGNotificationView"
```

## Author

ipagong, ipagong.dev@gmail.com

## License

PGNotificationView is available under the MIT license. See the LICENSE file for more info.
