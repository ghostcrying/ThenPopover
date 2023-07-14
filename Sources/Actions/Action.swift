import UIKit
import Foundation

/// Represents the default button for the popover popup
open class ThenPopoverAction: UIButton {
    
    public typealias ThenPopoverActionHandle = () -> Void
    
    
    // MARK: Public
    
    /// The font and size of the button title
    open dynamic var titleFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
    
    /// The height of the button
    open dynamic var buttonHeight: Int
    
    /// The title color of the button
    open dynamic var titleColor: UIColor? {
        get { return self.titleColor(for: UIControl.State()) }
        set { setTitleColor(newValue, for: UIControl.State()) }
    }
    
    /// The background color of the button
    open dynamic var buttonColor: UIColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }
    
    /// The separator color of this button
    open dynamic var separatorColor: UIColor? {
        get { return separator.backgroundColor }
        set {
            separator.backgroundColor = newValue
            leftSeparator.backgroundColor = newValue
        }
    }
    
    /// Default appearance of the button
    open var defaultTitleFont      = UIFont.systemFont(ofSize: 14)
    open var defaultTitleColor     = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
    open var defaultButtonColor    = UIColor.clear
    open var defaultSeparatorColor = UIColor(white: 0.9, alpha: 1)
    
    /// Whether button should dismiss popover when tapped
    open var dismissOnTap = true
    
    /// The action called when the button is tapped
    open fileprivate(set) var handler: ThenPopoverActionHandle?
    
    
    // MARK: Private
    
    fileprivate lazy var separator: UIView = {
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    fileprivate lazy var leftSeparator: UIView = {
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.alpha = 0
        return line
    }()
    
    // MARK: Internal
    
    internal var needsLeftSeparator: Bool = false {
        didSet {
            leftSeparator.alpha = needsLeftSeparator ? 1.0 : 0.0
        }
    }
    
    // MARK: Initializers
    
    /// Creates a action that can be added to the popover
    /// - Parameters:
    ///   - title: The action title
    ///   - height: action ui height
    ///   - dismissOnTap: Whether a tap automatically dismisses the popup
    ///   - handler: The action closure
    public init(title: String, height: Int = 45, dismissOnTap: Bool = true, handler: ThenPopoverActionHandle?) {
        
        // Assign the button height
        self.buttonHeight = height
        
        // Assign the button action
        self.handler = handler
        
        super.init(frame: .zero)
        
        // Set the button title
        setTitle(title, for: UIControl.State())
        
        self.dismissOnTap = dismissOnTap
        
        // Setup the views
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View setup
    
    open func setupView() {
        
        // Default appearance
        setTitleColor(defaultTitleColor, for: UIControl.State())
        titleLabel?.font              = defaultTitleFont
        backgroundColor               = defaultButtonColor
        separator.backgroundColor     = defaultSeparatorColor
        leftSeparator.backgroundColor = defaultSeparatorColor
        
        // Add and layout views
        addSubview(separator)
        addSubview(leftSeparator)
        
        let views = ["separator": separator, "leftSeparator": leftSeparator, "button": self]
        let metrics = ["buttonHeight": buttonHeight]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[separator(1)]", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftSeparator(1)]", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftSeparator]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }
    
    open override var isHighlighted: Bool {
        didSet {
            isHighlighted ? fadeAnimate(.out, 0.5) : fadeAnimate(.in, 1.0)
        }
    }
}

