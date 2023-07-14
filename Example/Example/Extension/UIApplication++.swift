import UIKit

public extension UIApplication {
    
    /// 适配iOS13的Window处理: 当前获取仅仅是第一个Scene
    var window: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared
                .connectedScenes
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?
                .windows
                .first
        } else {
            return UIApplication.shared.delegate?.window as? UIWindow
        }
    }
}
