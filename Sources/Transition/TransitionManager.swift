import Foundation
import UIKit

internal final class ThenPopoverTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    var presentedType: ThenPopoverTransition.TransitionType
    var dismissedType: ThenPopoverTransition.TransitionType
    private var overlay: ThenPopoverOverlayView
    private var interactor: InteractiveTransition

    init(presentedTransition: ThenPopoverTransition.TransitionType, dismissedTransition: ThenPopoverTransition.TransitionType? = nil, overlay: ThenPopoverOverlayView, interactor: InteractiveTransition) {
        presentedType = presentedTransition
        dismissedType = dismissedTransition ?? presentedTransition
        self.overlay = overlay
        self.interactor = interactor
        super.init()
    }

    func presentationController(forPresented presented: UIViewController, presenting _: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TransitionController(overlay: overlay, presentedViewController: presented, presenting: source)
    }

    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentedType.transition
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissedType.transition
    }

    func interactionControllerForDismissal(using _: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
