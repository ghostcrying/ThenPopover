import UIKit
import Foundation

final internal class ThenPopoverTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    var presentedType: ThenPopoverTransition.TransitionType
    var dismissedType: ThenPopoverTransition.TransitionType
    private var overlay: ThenPopoverOverlayView
    private var interactor: InteractiveTransition
    
    init(presentedTransition: ThenPopoverTransition.TransitionType, dismissedTransition: ThenPopoverTransition.TransitionType? = nil, overlay: ThenPopoverOverlayView, interactor: InteractiveTransition) {
        self.presentedType = presentedTransition
        self.dismissedType = dismissedTransition ?? presentedTransition
        self.overlay = overlay
        self.interactor = interactor
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TransitionController(overlay: overlay, presentedViewController: presented, presenting: source)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentedType.transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissedType.transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
