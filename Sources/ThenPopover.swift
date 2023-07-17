import UIKit
import Foundation

/// Creates a popover similar to UIAlertController
final public class ThenPopover: UIViewController {
    
    // MARK: - Private / Internal Properties
    
    /// First init flag
    fileprivate var initialized = false
    
    /// Width for iPad displays
    fileprivate let preferredWidth: PreferedWidth?
    
    /// The completion handler
    fileprivate var completion: (() -> Void)?
    
    /// The custom transition presentation manager
    fileprivate var presentationManager: ThenPopoverTransitionManager!
    
    /// Interactor class for pan gesture dismissal
    fileprivate lazy var interactor = InteractiveTransition()
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    fileprivate lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: interactor, action: #selector(InteractiveTransition.handlePan))
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    /// The set of actions
    fileprivate var actions = [ThenPopoverAction]()
    
    /// Whether keyboard has shifted view
    internal var keyboardShown = false
    
    /// Keyboard height
    internal var keyboardHeight: CGFloat?
    
    
    // MARK: - Public Properties
    
    /// Indicates if popup can be dismissed via tap gesture
    public var shouldDismissOnTap: Bool = true {
        didSet {
            guard oldValue != shouldDismissOnTap else { return }
            shouldDismissOnTap ?
            containerView.addGestureRecognizer(tapGesture) :
            containerView.removeGestureRecognizer(tapGesture)
        }
    }
    
    /// Indicates if popup can be dismissed via pan gesture
    public var shouldDismissOnPan: Bool = false {
        didSet {
            guard oldValue != shouldDismissOnPan else { return }
            shouldDismissOnPan ?
            containerView.stackView.addGestureRecognizer(panGesture) :
            containerView.stackView.removeGestureRecognizer(panGesture)
        }
    }
    
    /// StatusBar display related
    public var shouldHideStatusBar: Bool = false
    
    /// overlay
    public var overlay = ThenPopoverOverlayView()
    
    /// Returns the controllers view
    public var containerView: ThenPopoverContainerView {
        guard let view = view as? ThenPopoverContainerView else {
            fatalError("Unexpected view type")
        }
        return view
    }
    
    /// The content view of the popover
    public var viewController: UIViewController
    
    /// Whether or not to shift view for keyboard display
    public var keyboardShiftsView = true
    
    // MARK: - Initializers
    
    /// Creates a standard popover with title, message and image field
    /// - Parameters:
    ///   - title: The popup title
    ///   - message: The popup message
    ///   - image: The popup image
    ///   - actionsAxis: The popup button axis
    ///   - presentedTransitionStyle: The popup present transition style
    ///   - dismissedTransitionStyle: The popup dismiss transition style
    ///   - preferredWidth: The preferred width for iPad screens
    ///   - completion: Completion block invoked when popup was dismissed
    public convenience init(title: String?,
                            message: String?,
                            image: UIImage? = nil,
                            axis actionsAxis: NSLayoutConstraint.Axis = .horizontal,
                            presented presentedTransitionStyle: ThenPopoverTransition.TransitionType = .default,
                            dismissed dismissedTransitionStyle: ThenPopoverTransition.TransitionType? = nil,
                            width preferredWidth: PreferedWidth? = .default,
                            completion: (() -> Void)? = nil)
    {
        let viewController = ThenPopoverDefaultController()
        viewController.image       = image
        viewController.titleText   = title
        viewController.messageText = message
        
        self.init(viewController, axis: actionsAxis, presented: presentedTransitionStyle, dismissed: dismissedTransitionStyle, width: preferredWidth, completion: completion)
    }
    
    /// Creates a popover containing a custom view
    /// - Parameters:
    ///   - conttoller: A custom view controller to be displayed
    ///   - actionsAxis: The popup button axis
    ///   - presentedTransitionStyle: The popup present transition style
    ///   - dismissedTransitionStyle: The popup dismess transition style
    ///   - preferredWidth: The preferred width for iPad screens
    ///   - completion: Completion block invoked when popup was dismissed
    public init(_ conttoller: UIViewController,
                axis actionsAxis: NSLayoutConstraint.Axis = .horizontal,
                presented presentedTransitionStyle: ThenPopoverTransition.TransitionType = .default,
                dismissed dismissedTransitionStyle: ThenPopoverTransition.TransitionType? = nil,
                width preferredWidth: PreferedWidth? = .default,
                completion: (() -> Void)? = nil)
    {
        self.viewController = conttoller
        self.preferredWidth = preferredWidth
        self.completion     = completion
        super.init(nibName: nil, bundle: nil)
        
        // Init the presentation manager
        self.presentationManager = ThenPopoverTransitionManager(presentedTransition: presentedTransitionStyle, dismissedTransition: dismissedTransitionStyle, overlay: overlay, interactor: interactor)
        
        // Assign the interactor view controller
        self.interactor.viewController = self
        
        // axis
        self.actionsAxis = actionsAxis
        
        // Define presentation styles
        transitioningDelegate = presentationManager
        modalPresentationStyle = .custom
        
        // StatusBar setup
        modalPresentationCapturesStatusBarAppearance = true
        
        // Add our custom view to the container
        addChild(viewController)
        containerView.stackView.insertArrangedSubview(viewController.view, at: 0)
        viewController.didMove(toParent: self)
        
        // gesture
        containerView.addGestureRecognizer(tapGesture)
    }
    
    // Init with coder not implemented
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    /// Replaces controller view with popup view
    public override func loadView() {
        view = ThenPopoverContainerView(frame: UIScreen.main.bounds, preferredWidth: preferredWidth)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        
        if !initialized {
            appendActions()
            initialized = true
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.15) { self.setNeedsStatusBarAppearanceUpdate() }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    deinit {
        completion?()
        completion = nil
    }
    
    // MARK: - StatusBar display related
    
    public override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

// MARK: - Action related

extension ThenPopover {
    
    /// Appends the actions added to the popover
    fileprivate func appendActions() {
        
        let stackView = containerView.stackView
        let buttonStackView = containerView.actionStackView
        
        if actions.isEmpty { stackView.removeArrangedSubview(containerView.actionStackView) }
        
        for (index, action) in actions.enumerated() {
            action.needsLeftSeparator = buttonStackView.axis == .horizontal && index > 0
            buttonStackView.addArrangedSubview(action)
            action.addTarget(self, action: #selector(actionHandler(_:)), for: .touchUpInside)
        }
    }
    
    /// Adds an array of ThenPopoverAction to the popover
    public func addActions(_ actions: [ThenPopoverAction]) {
        if !initialized {
            self.actions += actions
        }
    }
    
    /// Simulates a button tap for the given index
    public func simulateActionHandle(index: Int) {
        guard index < actions.count else {
            print("simulateActionHandle error: index beyond actions count.")
            return
        }
        actions[index].handler?()
    }
    
    /// Calls the action closure of the button instance tapped
    @objc fileprivate func actionHandler(_ action: ThenPopoverAction) {
        if action.dismissOnTap {
            dismiss({ action.handler?() })
        } else {
            action.handler?()
        }
    }
}

// MARK: - Dismissal related

extension ThenPopover {
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: containerView.stackView)
        guard !containerView.stackView.point(inside: point, with: nil) else {
            return
        }
        dismiss()
    }
    
    /// Dismissed the popover
    public func dismiss(_ completion: (() -> Void)? = nil) {
        self.dismiss(animated: true, completion: completion)
    }
    
}

// MARK: - View proxy values

extension ThenPopover {
    
    /// The button alignment of the alert popup
    public var actionsAxis: NSLayoutConstraint.Axis {
        get { return containerView.actionStackView.axis }
        set {
            containerView.actionStackView.axis = newValue
            containerView.layoutIfNeededAnimated()
        }
    }
    
    /// The transition style for presenting the popover
    public var presentedTransitionStyle: ThenPopoverTransition.TransitionType {
        get { return presentationManager.presentedType }
        set { presentationManager.presentedType = newValue }
    }
    
    /// The transition style for dismissing the popover
    public var dismissedTransitionStyle: ThenPopoverTransition.TransitionType {
        get { return presentationManager.dismissedType }
        set { presentationManager.dismissedType = newValue }
    }
}

// MARK: - Shake

extension ThenPopover {
    
    /// Performs a shake animation on the popup
    public func shakeAnimate() {
        containerView.shakeAnimate()
    }
}
