import UIKit

public extension ThenPopoverTransition {
    
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
        
        public var transition: ThenPopoverTransition {
            switch self {
            case .translation(let value):
                return TranslationTransition(value)
            case .default:
                return FadeTransition()
            case .scale:
                return ScaleTransition()
            case .rotate(let value):
                return RotateTransition(value)
            case .custom(let value):
                return value
            case .corner(let value):
                return CornerTransition(value)
            }
        }
    }
    
}

internal class FadeTransition: ThenPopoverTransition {
    
    override public func beforeAnimation(using transitionContext: TransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 0.0 : 1.0
    }
    
    override public func performAnimation(using transitionContext: TransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 1.0 : 0.0
    }
    
    override public func afterAnimation(using transitionContext: TransitionContext) {
        transitionContext.animatingView?.alpha = 1.0
    }
    
}

internal class TranslationTransition: ThenPopoverTransition {
    
    private let direction: TransitionType.Translation
    
    init(_ direction: TransitionType.Translation = .left) {
        self.direction = direction
    }
    
    override public func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        switch direction {
        case .left:
            initialFrame.origin.x = 0 - initialFrame.size.width
        case .right:
            initialFrame.origin.x = containerFrame.size.width + initialFrame.size.width
        case .top:
            initialFrame.origin.y = 0 - initialFrame.size.height
        case .bottom:
            initialFrame.origin.y = containerFrame.height + initialFrame.height
        }
        return initialFrame
    }
    
}

internal class CornerTransition: ThenPopoverTransition {
    
    let corner: TransitionType.Corner
    
    public init(_ corner: TransitionType.Corner) {
        self.corner = corner
    }
    
    override public func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        
        switch corner {
        case .topLeft:
            initialFrame.origin = CGPoint(x: -initialFrame.size.width,
                                          y: -initialFrame.size.height)
        case .topRight:
            initialFrame.origin = CGPoint(x: containerFrame.size.width + initialFrame.size.width,
                                          y: -initialFrame.size.height)
        case .bottomLeft:
            initialFrame.origin = CGPoint(x: -initialFrame.size.width,
                                          y: containerFrame.size.height + initialFrame.size.height)
        case .bottomRight:
            initialFrame.origin = CGPoint(x: containerFrame.size.width + initialFrame.size.width,
                                          y: containerFrame.size.height + initialFrame.size.height)
        }
        return initialFrame
    }
    
}

internal class ScaleTransition: ThenPopoverTransition {
    
    override public func beforeAnimation(using transitionContext: TransitionContext) {
        if transitionContext.isPresenting {
            transitionContext.animatingView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
    }
    
    override public func performAnimation(using transitionContext: TransitionContext) {
        if transitionContext.isPresenting {
            transitionContext.animatingView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        } else {
            transitionContext.animatingView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
    }
}

internal class RotateTransition: ThenPopoverTransition {
    
    private let direction: TransitionType.Rotate
    
    init(_ direction: TransitionType.Rotate = .x) {
        self.direction = direction
    }
    
    override func beforeAnimation(using transitionContext: ThenPopoverTransition.TransitionContext) {
        guard case .z(let laps) = direction else {
            return
        }
        switch transitionContext.isPresenting {
        case true:
            transitionContext.toView?.alpha = 0
            
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnimation.fromValue = 0
            rotateAnimation.toValue = 2.0 * CGFloat.pi
            rotateAnimation.duration = 0.1
            rotateAnimation.repeatCount = Float(laps)
            rotateAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.1
            scaleAnimation.toValue = 1
            scaleAnimation.duration = 0.1 * Double(laps)
            scaleAnimation.isRemovedOnCompletion = true
            
            let animations = CAAnimationGroup()
            animations.animations = [rotateAnimation, scaleAnimation]
            animations.duration = 0.1 * Double(laps)
            animations.isRemovedOnCompletion = true
            
            transitionContext.toView?.layer.add(animations, forKey: "transform.scale.roation")
        default:
            transitionContext.fromView?.alpha = 1
            
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnimation.fromValue = 0
            rotateAnimation.toValue = 2.0 * CGFloat.pi
            rotateAnimation.duration = 0.1
            rotateAnimation.repeatCount = Float(laps)
            rotateAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = 0.1
            scaleAnimation.duration = 0.1 * Double(laps)
            scaleAnimation.isRemovedOnCompletion = true
            
            let animations = CAAnimationGroup()
            animations.animations = [rotateAnimation, scaleAnimation]
            animations.duration = 0.1 * Double(laps)
            animations.isRemovedOnCompletion = true
            
            transitionContext.fromView?.layer.add(animations, forKey: "transform.scale.roation")
        }
    }
    
    override public func performAnimation(using transitionContext: TransitionContext) {
        switch direction {
        case .z:
            transitionContext.toView?.alpha = transitionContext.isPresenting ? 1 : 0
        case .x:
            // This is to make sure transform/animation does not go behind background "chrome" view.
            transitionContext.toView?.layer.zPosition = 999
            transitionContext.fromView?.layer.zPosition = 999
            
            var fromViewTransform = CATransform3DIdentity
            fromViewTransform.m34 = -0.003
            fromViewTransform = CATransform3DRotate(fromViewTransform, .pi / 2.0, 0.0, -1.0, 0.0)
            
            var toViewTransform = CATransform3DIdentity
            toViewTransform.m34 = -0.003
            toViewTransform = CATransform3DRotate(toViewTransform, .pi / 2.0, 0.0, 1.0, 0.0)
            transitionContext.toView?.layer.transform = toViewTransform
            
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
                transitionContext.fromView?.layer.transform = fromViewTransform
            }) { _ in
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
                    transitionContext.toView?.layer.transform = CATransform3DMakeRotation(.pi / 2.0, 0.0, 0.0, 0.0)
                }) { _ in }
            }
        default:
            // This is to make sure transform/animation does not go behind background "chrome" view.
            transitionContext.toView?.layer.zPosition = 999
            transitionContext.fromView?.layer.zPosition = 999
            
            var fromViewTransform = CATransform3DIdentity
            fromViewTransform.m34 = -0.003
            fromViewTransform = CATransform3DRotate(fromViewTransform, .pi / 2.0, -1.0, 0.0, 0.0)
            
            var toViewTransform = CATransform3DIdentity
            toViewTransform.m34 = -0.003
            toViewTransform = CATransform3DRotate(toViewTransform, .pi / 2.0, 1.0, 0.0, 0.0)
            transitionContext.toView?.layer.transform = toViewTransform
            
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
                transitionContext.fromView?.layer.transform = fromViewTransform
            }) { _ in
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
                    transitionContext.toView?.layer.transform = CATransform3DMakeRotation(.pi / 2.0, 0.0, 0.0, 0.0)
                }) { _ in }
            }
        }
    }
    
}
