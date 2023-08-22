import Foundation
import UIKit

/// The intended direction of the animation
internal enum AnimationDirection {
    case `in` // Animate in
    case out  // Animate out
}

/// The key for the fade animation
private let fadeKey = "com.then.popover.animate.key.fade"
private let shakeKey = "com.then.popover.animate.key.shake"

internal extension UIView {
    func fadeAnimate(_: AnimationDirection, _ value: Float, duration: CFTimeInterval = 0.08) {
        layer.removeAnimation(forKey: fadeKey)
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = layer.presentation()?.opacity
        layer.opacity = value
        animation.fillMode = CAMediaTimingFillMode.forwards
        layer.add(animation, forKey: fadeKey)
    }

    func layoutIfNeededAnimated(duration: CFTimeInterval = 0.08) {
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

    // As found at https://gist.github.com/mourad-brahim/cf0bfe9bec5f33a6ea66#file-uiview-animations-swift-L9
    // Slightly modified
    func shakeAnimate() {
        layer.removeAnimation(forKey: shakeKey)
        let vals: [Double] = [-2, 2, -2, 2, 0]

        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = vals

        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = vals.map { (degrees: Double) in
            let radians: Double = (Double.pi * degrees) / 180.0
            return radians
        }

        let shakeGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = 0.3
        layer.add(shakeGroup, forKey: shakeKey)
    }
}
