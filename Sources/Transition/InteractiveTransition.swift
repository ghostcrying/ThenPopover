import Foundation
import UIKit

/// Handles interactive transition triggered via pan gesture recognizer on popup
internal final class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    /// If the interactive transition was started
    var hasStarted = false

    /// If the interactive transition
    var shouldFinish = false

    /// The view controller containing the views with attached gesture recognizers
    weak var viewController: UIViewController?

    @objc
    func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let vc = viewController, let progress = calculateProgress(sender: sender) else {
            return
        }

        switch sender.state {
        case .began:
            hasStarted = true
            vc.dismiss(animated: true, completion: nil)
        case .changed:
            shouldFinish = progress > 0.3
            update(progress)
        case .cancelled:
            hasStarted = false
            cancel()
        case .ended:
            hasStarted = false
            completionSpeed = 0.55
            shouldFinish ? finish() : cancel()
        default:
            break
        }
    }
}

internal extension InteractiveTransition {
    /// Translates the pan gesture recognizer position to the progress percentage
    /// - Parameter sender: A UIPanGestureRecognizer
    /// - Returns: Progress
    func calculateProgress(sender: UIPanGestureRecognizer) -> CGFloat? {
        guard let vc = viewController else {
            return nil
        }

        // http://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/
        let translation = sender.translation(in: vc.view)
        let verticalMovement = translation.y / vc.view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        return progress
    }
}
