import UIKit

internal extension UIViewController {
    var isTopAndVisible: Bool {
        return isVisible && isTopViewController
    }

    var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }

    var isTopViewController: Bool {
        if navigationController != nil {
            return navigationController?.visibleViewController === self
        }
        if tabBarController != nil {
            return tabBarController?.selectedViewController == self && presentedViewController == nil
        }
        return presentedViewController == nil && isVisible
    }
}
