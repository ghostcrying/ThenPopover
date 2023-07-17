# ThenPopover



## Installation

#### Cocoapods

```
pod 'ThenPopover'
```



#### Carthage

```
github "ghostcrying/ThenPopover"
```

###### 校验Carthage

```
carthage build --no-skip-current --platform ios --use-xcframeworks
```



#### Swift Package Manager

```
https://github.com/ghostcrying/ThenPopover.git
```


## Origin
- ThenPopover: https://github.com/Orderella/ThenPopover
- Presentr: https://github.com/IcaliaLabs/Presentr



# Example

You can find this and more example projects in the repo. To run it, clone the repo, and run `pod install` from the Example directory first.

```swift
import ThenPopover

let title = "Default Title"
let message = "Message Default view"
let image = UIImage(named: "...")

// Create the popup
let popover = ThenPopover(title: title, message: message, image: image, width: .custom(320))
popover.containerView.cornerRadius = 12
popover.containerView.shadowEnabled = false
// Create first button
let actionOne = ThenPopoverAction.Cancel(title: "CANCEL") {
    print("Click the Cancel the image popover.")
}
let actionTwo = ThenPopoverAction.Default(title: "SHAKE", dismissOnTap: false) { [weak popover] in
    popover?.shakeAnimate()
}
let actionThree = ThenPopoverAction.Default(title: "OK") {
    print("Click the OK the image popover.")
}
popover.addActions([actionOne, actionTwo, actionThree])

self?.present(popover, animated: true, completion: nil)
```

<p>&nbsp;</p>

# Usage

ThenPopover is a subclass of UIViewController and as such can be added to your view controller modally. You can initialize it either with the handy default view or a custom view controller.

## Default Dialog

```swift
public convenience init(
    title: String?,
    message: String?,
    image: UIImage? = nil,
    axis actionsAxis: NSLayoutConstraint.Axis = .horizontal,
    presented presentedTransitionStyle: ThenPopoverTransition.TransitionType = .default,
    dismissed dismissedTransitionStyle: ThenPopoverTransition.TransitionType? = nil,
    width preferredWidth: PreferedWidth? = .default,
    completion: (() -> Void)? = nil)
```

The default dialog initializer is a convenient way of creating a popover with image, title and message (see image one and three).

Bascially, all parameters are optional, although this makes no sense at all. You want to at least add a message and a single button, otherwise the dialog can't be dismissed, unless you do it manually.

If you provide an image it will be pinned to the top/left/right of the dialog. The ratio of the image will be used to set the height of the image view, so no distortion will occur.

## Custom View Controller

```swift
public init(
    _ conttoller: UIViewController,
    axis actionsAxis: NSLayoutConstraint.Axis = .horizontal,
    presented presentedTransitionStyle: ThenPopoverTransition.TransitionType = .default,
    dismissed dismissedTransitionStyle: ThenPopoverTransition.TransitionType? = nil,
    width preferredWidth: PreferedWidth? = .default,
    completion: (() -> Void)? = nil)
```

You can pass your own view controller to ThenPopover (see image two). It is accessible via the `viewController` property of ThenPopover, which has to be casted to your view controllers class to access its properties. Make sure the custom view defines all constraints needed, so you don't run into any autolayout issues.

Actions are added below the controllers view, however, these Actions are optional. If you decide to not add any Actions, you have to take care of dismissing the dialog manually. Being a subclass of view controller, this can be easily done via `dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?)`.

## Action Alignment

Actions can be distributed either `.horizontal` or `.vertical`, with the latter being the default. Please note distributing Actions horizontally might not be a good idea if you have more than two Actions.

```swift
public enum UILayoutConstraintAxis : Int {
	case horizontal
	case vertical
}
```

## Transition Style

You can set a transition animation style with `.bounceUp` being the default. The following transition styles are available

```swift
enum TransitionType {

    public enum Translation {
        case left
        case right
        case top
        case bottom
    }

    public enum Rotate {
        case x
        case y
        case z(_ laps: Int)
    }

    public enum Corner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    /// fade in out
    case `default`
    /// translation in out
    case translation(_ direction: Translation)
    /// scale in out
    case scale

    case rotate(_ value: Rotate)
    case corner(_ value: Corner)
    case custom(_ value: ThenPopoverTransition)
}
```

## Preferred Width

ThenPopover will always try to have a max width of `UIScreen.main.bounds.size.width - 48` .
But 900 is the standard width for iPads.

```
enum PreferedWidth {
    case `default`
    case custom(_ value: CGFloat)

    public var width: CGFloat {
        switch self {
        case .custom(let value):
            return value
        default:
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                return 900
            }
            // 左右边距: 24
            return UIScreen.main.bounds.size.width - 48
        }
    }
}
```



## Gesture Dismissal

Gesture dismissal allows your dialog being dismissed either by a background tap or by swiping the dialog down. By default, this is set to `true`. You can prevent this behavior by setting either `tapGestureDismissal` or `panGestureDismissal`  to `false` in the initializer.

## Hide Status Bar

ThenPopover can hide the status bar whenever it is displayed. Defaults to `false`. Make sure to add `UIViewControllerBasedStatusBarAppearance` to `Info.plist` and set it to `YES`.

## Completion

This completion handler is called when the dialog was dismissed. This is especially useful for catching a gesture dismissal.

<p>&nbsp;</p>

# Default Popover Properties

If you are using the default dialog, you can change selected properties at runtime:

```swift
// Create
let pop = ThenPopover(title: title, message: message, image: image)

// Present
self.present(pop, animated: true, completion: nil)

// Get the default view controller and cast it
let vc = pop.viewController as! ThenPopoverDefaultViewController

// Set
vc.image = UIImage(...)
vc.titleText = "..."
vc.messageText = "..."
vc.buttonAlignment = .horizontal
vc.transitionStyle = .bounceUp
```

<p>&nbsp;</p>

# Styling ThenPopover

Appearance is the preferred way of customizing the style of ThenPopover.
The idea of ThenPopover is to define a theme in a single place, without having to provide style settings with every single instantiation. This way, creating a ThenPopover requires only minimal code to be written and no "wrappers".

This makes even more sense, as popover dialogs and alerts are supposed to look consistent throughout the app, that is, maintain a single style.

## Dialog Default View Appearance Settings

If you are using the default popup view, the following appearance settings are available:

```swift
let dialogAppearance = ThenPopoverDefaultView.appearance()

dialogAppearance.backgroundColor      = .white
dialogAppearance.titleFont            = .boldSystemFont(ofSize: 14)
dialogAppearance.titleColor           = UIColor(white: 0.4, alpha: 1)
dialogAppearance.titleTextAlignment   = .center
dialogAppearance.messageFont          = .systemFont(ofSize: 14)
dialogAppearance.messageColor         = UIColor(white: 0.6, alpha: 1)
dialogAppearance.messageTextAlignment = .center
```

## Dialog Container Appearance Settings

The container view contains the ThenPopoverDefaultView or your custom view controller. the following appearance settings are available:

```swift
let containerAppearance = ThenPopoverContainerView.appearance()

containerAppearance.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
containerAppearance.cornerRadius    = 2
containerAppearance.shadowEnabled   = true
containerAppearance.shadowColor     = .black
containerAppearance.shadowOpacity   = 0.6
containerAppearance.shadowRadius    = 20
containerAppearance.shadowOffset    = CGSize(width: 0, height: 8)
containerAppearance.shadowPath      = CGPath(...)
```

## Overlay View Appearance Settings

This refers to the view that is used as an overlay above the underlying view controller but below the popup dialog view. If that makes sense ;)

```swift
let overlayAppearance = ThenPopoverOverlayView.appearance()

overlayAppearance.color           = .black
overlayAppearance.blurRadius      = 20
overlayAppearance.blurEnabled     = true
overlayAppearance.liveBlurEnabled = false
overlayAppearance.opacity         = 0.7
```

#### Note

Setting `liveBlurEnabled` to true, that is enabling realtime updates of the background view, results in a significantly higher CPU usage /power consumption and is therefore turned off by default. Choose wisely whether you need this feature or not ;)

## Action Appearance Settings

The standard button classes available are `Default`, `Cancel` and `Destructive`. All Actions feature the same appearance settings and can be styled separately.

```swift
var buttonAppearance = ThenPopoverAction.Default.appearance()

// Default action
buttonAppearance.titleFont      = .systemFont(ofSize: 14)
buttonAppearance.titleColor     = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
buttonAppearance.buttonColor    = .clear
buttonAppearance.separatorColor = UIColor(white: 0.9, alpha: 1)

// Below, only the differences are highlighted

// Cancel action
ThenPopoverAction.Cancel.appearance().titleColor = .lightGray

// Destructive action
ThenPopoverAction.Destructive.appearance().titleColor = .red
```

Moreover, you can create a custom button by subclassing `ThenPopoverAction`. The following example creates a solid blue button, featuring a bold white title font. Separators are invisible.

```swift
public final class SolidBlueButton: ThenPopoverAction {

    override public func setupView() {
        defaultFont           = .boldSystemFont(ofSize: 16)
        defaultTitleColor     = .white
        defaultButtonColor    = .blue
        defaultSeparatorColor = .clear
        super.setupView()
    }
}

```

These actions can be customized with the appearance settings given above as well.

## Dark mode example

The following is an example of a *Dark Mode* theme. You can find this in the Example project `AppDelegate`, just uncomment it to apply the custom appearance.

```swift
// Customize dialog appearance
let pv = ThenPopoverDefaultView.appearance()
pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
pv.titleColor   = .white
pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
pv.messageColor = UIColor(white: 0.8, alpha: 1)

// Customize the container view appearance
let pcv = ThenPopoverContainerView.appearance()
pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
pcv.cornerRadius    = 2
pcv.shadowEnabled   = true
pcv.shadowColor     = .black

// Customize overlay appearance
let ov = ThenPopoverOverlayView.appearance()
ov.blurEnabled     = true
ov.blurRadius      = 30
ov.liveBlurEnabled = true
ov.opacity         = 0.7
ov.color           = .black

// Customize default button appearance
let db = ThenPopoverAction.Default.appearance()
db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
db.titleColor     = .white
db.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)

// Customize cancel button appearance
let cb = ThenPopoverAction.Cancel.appearance()
cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
cb.titleColor     = UIColor(white: 0.6, alpha: 1)
cb.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
cb.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)

```

# Working with fields

If you are using text fields in your custom view controller, popover dialog makes sure that the dialog is positioned above the keyboard whenever it appears. You can opt out of this behaviour by setting `keyboardShiftsView` to false on a Popover Dialog.

# Testing

ThenPopover exposes a nice and handy method that lets you trigger a button tap programmatically:

```swift
public func simulateActionHandle(_ index: Int)
```

Other than that, ThenPopover unit tests are included in the root folder.

<p>&nbsp;</p>


# Bonus

## Shake animation

If you happen to use ThenPopover to validate text input, for example, you can call the handy `shake()` method on ThenPopover.

<p>&nbsp;</p>

# Requirements

Minimum requirement is iOS 11.0. This dialog was written with Swift 5.0, for support of older versions please head over to releases.
