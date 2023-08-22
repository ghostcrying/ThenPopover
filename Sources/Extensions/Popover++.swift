import Foundation
import UIKit

/// This extension is designed to handle popup positioning if a keyboard is displayed while the popover
internal extension ThenPopover {
    // MARK: - Keyboard & orientation observers

    /// Add obserservers for UIKeyboard notifications
    func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    /// Remove observers
    func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    // MARK: - Actions

    /// Keyboard will show notification listener
    /// - Parameter notification: NSNotification
    @objc
    fileprivate func keyboardWillShow(_: Notification) {
        guard isTopAndVisible else {
            return
        }
        keyboardShown = true
        centerPopover()
    }

    /// Keyboard will hide notification listener
    /// - Parameter notification: NSNotification
    @objc
    fileprivate func keyboardWillHide(_: Notification) {
        guard isTopAndVisible else {
            return
        }
        keyboardShown = false
        centerPopover()
    }

    /// Keyboard will change frame notification listener
    /// - Parameter notification: NSNotification
    @objc
    fileprivate func keyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardRect = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardHeight = keyboardRect.cgRectValue.height
    }

    /// Listen to orientation changes
    /// - Parameter notification: NSNotification
    @objc
    fileprivate func orientationChanged(_: Notification) {
        if keyboardShown {
            centerPopover()
        }
    }

    fileprivate func centerPopover() {
        // Make sure keyboard should reposition on keayboard notifications
        guard keyboardShiftsView else {
            return
        }

        // Make sure a valid keyboard height is available
        guard let keyboardHeight = keyboardHeight else {
            return
        }

        // Calculate new center of shadow background
        let constant = keyboardShown ? keyboardHeight / -2 : 0

        // Reposition and animate
        containerView.centerYConstraint?.constant = constant
        containerView.layoutIfNeededAnimated()
    }
}
