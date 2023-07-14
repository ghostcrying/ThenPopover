import UIKit

// MARK: Default button

extension ThenPopoverAction {
    
    /// Represents the default button for the popover
    public final class Default: ThenPopoverAction {}
}

// MARK: Cancel button

extension ThenPopoverAction {
    
    /// Represents a cancel button for the popover
    public final class Cancel: ThenPopoverAction {
        
        override public func setupView() {
            defaultTitleColor = UIColor.lightGray
            super.setupView()
        }
    }
    
}

// MARK: destructive button

extension ThenPopoverAction {
    
    /// Represents a destructive button for the popover
    public final class Destructive: ThenPopoverAction {
        
        override public func setupView() {
            defaultTitleColor = UIColor.red
            super.setupView()
        }
    }
    
}

