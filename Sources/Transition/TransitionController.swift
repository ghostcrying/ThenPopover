import UIKit
import Foundation

final internal class TransitionController: UIPresentationController {
    
    private var overlay: ThenPopoverOverlayView
    
    init(overlay: ThenPopoverOverlayView, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.overlay = overlay
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        
        guard let containerView = containerView else { return }
        
        overlay.frame = containerView.bounds
        containerView.insertSubview(overlay, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.overlay.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.overlay.alpha = 0.0
        }, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        
        guard let presentedView = presentedView else {
            return
        }
        presentedView.frame = frameOfPresentedViewInContainerView
    }
    
}
