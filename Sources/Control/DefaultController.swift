import UIKit

final public class ThenPopoverDefaultController: UIViewController {
    
    public var standardView: ThenPopoverDefaultView {
        return view as! ThenPopoverDefaultView
    }
    
    override public func loadView() {
        super.loadView()
        view = ThenPopoverDefaultView(frame: .zero)
    }
}

public extension ThenPopoverDefaultController {
    
    // MARK: - Setter / Getter
    
    // MARK: Content
    
    /// The popup image
    var image: UIImage? {
        get { return standardView.imageView.image }
        set {
            standardView.imageView.image = newValue
            standardView.imageHeightConstraint?.constant = standardView.imageView.popoverHeight()
        }
    }
    
    /// The title text of the popup
    var titleText: String? {
        get { return standardView.titleLabel.text }
        set {
            standardView.titleLabel.text = newValue
            standardView.layoutIfNeededAnimated()
        }
    }
    
    /// The message text of the popup
    var messageText: String? {
        get { return standardView.messageLabel.text }
        set {
            standardView.messageLabel.text = newValue
            standardView.layoutIfNeededAnimated()
        }
    }
    
    // MARK: Appearance
    
    /// The font and size of the title label
    var titleFont: UIFont {
        get { return standardView.titleFont }
        set {
            standardView.titleFont = newValue
            standardView.layoutIfNeededAnimated()
        }
    }
    
    /// The color of the title label
    var titleColor: UIColor? {
        get { return standardView.titleLabel.textColor }
        set {
            standardView.titleColor = newValue
            standardView.layoutIfNeededAnimated()
        }
    }
    
    /// The text alignment of the title label
    var titleTextAlignment: NSTextAlignment {
        get { return standardView.titleTextAlignment }
        set {
            standardView.titleTextAlignment = newValue
            standardView.layoutIfNeededAnimated()
        }
    }
    
    /// The font and size of the body label
    var messageFont: UIFont {
        get { return standardView.messageFont}
        set {
            standardView.messageFont = newValue
            standardView.layoutIfNeededAnimated()
        }
    }
    
    /// The color of the message label
    var messageColor: UIColor? {
        get { return standardView.messageColor }
        set {
            standardView.messageColor = newValue
            standardView.layoutIfNeededAnimated()
        }
    }
    
    /// The text alignment of the message label
    var messageTextAlignment: NSTextAlignment {
        get { return standardView.messageTextAlignment }
        set {
            standardView.messageTextAlignment = newValue
            standardView.layoutIfNeededAnimated()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        standardView.imageHeightConstraint?.constant = standardView.imageView.popoverHeight()
    }
}

