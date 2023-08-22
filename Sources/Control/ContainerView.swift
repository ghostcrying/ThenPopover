import Foundation
import UIKit

public extension ThenPopover {
    enum PreferedWidth {
        case `default`
        case custom(_ value: CGFloat)

        public var width: CGFloat {
            switch self {
            case let .custom(value):
                return value
            default:
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    return 900
                }
                // 左右边距: 24
                return UIScreen.main.bounds.size.width - 48
            }
        }
    }
}

/// The main view of the popover
public final class ThenPopoverContainerView: UIView {
    // MARK: - Appearance

    /// The background color of the popover
    override public var backgroundColor: UIColor? {
        get { return container.backgroundColor }
        set { container.backgroundColor = newValue }
    }

    /// The corner radius of the popover view
    public var cornerRadius: Float {
        get { return Float(shadowContainer.layer.cornerRadius) }
        set {
            let radius = CGFloat(newValue)
            shadowContainer.layer.cornerRadius = radius
            container.layer.cornerRadius = radius
        }
    }

    // MARK: Shadow related

    /// Enable / disable shadow rendering of the container
    public var shadowEnabled: Bool {
        get { return shadowContainer.layer.shadowRadius > 0 }
        set { shadowContainer.layer.shadowRadius = newValue ? shadowRadius : 0 }
    }

    /// Color of the container shadow
    public var shadowColor: UIColor? {
        get {
            guard let color = shadowContainer.layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set { shadowContainer.layer.shadowColor = newValue?.cgColor }
    }

    /// Radius of the container shadow
    public var shadowRadius: CGFloat {
        get { return shadowContainer.layer.shadowRadius }
        set { shadowContainer.layer.shadowRadius = newValue }
    }

    /// Opacity of the the container shadow
    public var shadowOpacity: Float {
        get { return shadowContainer.layer.shadowOpacity }
        set { shadowContainer.layer.shadowOpacity = newValue }
    }

    /// Offset of the the container shadow
    public var shadowOffset: CGSize {
        get { return shadowContainer.layer.shadowOffset }
        set { shadowContainer.layer.shadowOffset = newValue }
    }

    /// Path of the the container shadow
    public var shadowPath: CGPath? {
        get { return shadowContainer.layer.shadowPath }
        set { shadowContainer.layer.shadowPath = newValue }
    }

    // MARK: - Views

    /// The shadow container is the basic view of the Popover
    /// As it does not clip subviews, a shadow can be applied to it
    internal lazy var shadowContainer: UIView = {
        let shadowContainer = UIView(frame: .zero)
        shadowContainer.translatesAutoresizingMaskIntoConstraints = false
        shadowContainer.backgroundColor = UIColor.clear
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowRadius = 5
        shadowContainer.layer.shadowOpacity = 0.4
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowContainer.layer.cornerRadius = 12
        return shadowContainer
    }()

    /// The container view is a child of shadowContainer and contains
    /// all other views. It clips to bounds so cornerRadius can be set
    internal lazy var container: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white
        container.clipsToBounds = true
        container.layer.cornerRadius = 12
        return container
    }()

    // The container stack view for buttons
    internal lazy var actionStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 0
        return buttonStackView
    }()

    // The main stack view, containing all relevant views
    internal lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.actionStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    // The preferred width for iPads
    fileprivate let preferredWidth: ThenPopover.PreferedWidth?

    // MARK: - Constraints

    /// The center constraint of the shadow container
    internal var centerYConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    internal init(frame: CGRect, preferredWidth: ThenPopover.PreferedWidth?) {
        self.preferredWidth = preferredWidth
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    internal func setupViews() {
        // Add views
        addSubview(shadowContainer)
        shadowContainer.addSubview(container)
        container.addSubview(stackView)

        if let width = preferredWidth?.width {
            let constrant = shadowContainer.widthAnchor.constraint(equalToConstant: width)
            // the view maybe has higher priority, so can't set value with 1000.
            constrant.priority = .init(900)
            constrant.isActive = true
        }
        NSLayoutConstraint.activate([
            // shadow
            shadowContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            shadowContainer.centerYAnchor.constraint(equalTo: centerYAnchor),

            // container
            container.leftAnchor.constraint(equalTo: shadowContainer.leftAnchor),
            container.rightAnchor.constraint(equalTo: shadowContainer.rightAnchor),
            container.topAnchor.constraint(equalTo: shadowContainer.topAnchor),
            container.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor),

            // stackview
            stackView.leftAnchor.constraint(equalTo: container.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: container.rightAnchor),
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}
