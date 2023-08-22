import UIKit

// MARK: Default button

public extension ThenPopoverAction {
    /// Represents the default button for the popover
    final class Default: ThenPopoverAction {}
}

// MARK: Cancel button

public extension ThenPopoverAction {
    /// Represents a cancel button for the popover
    final class Cancel: ThenPopoverAction {
        override public func setupView() {
            defaultTitleColor = UIColor.lightGray
            super.setupView()
        }
    }
}

// MARK: destructive button

public extension ThenPopoverAction {
    /// Represents a destructive button for the popover
    final class Destructive: ThenPopoverAction {
        override public func setupView() {
            defaultTitleColor = UIColor.red
            super.setupView()
        }
    }
}
