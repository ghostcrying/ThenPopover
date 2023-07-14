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
        if self.navigationController != nil {
            return self.navigationController?.visibleViewController === self
        } else if self.tabBarController != nil {
            return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
        } else {
            return self.presentedViewController == nil && self.isVisible
        }
    }
}

