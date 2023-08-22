import Foundation
import UIKit

/// The (blurred) overlay view below the popover
public final class ThenPopoverOverlayView: UIView {
    // MARK: - Appearance

    /// Turns of the blur effect on or off: default off
    public var blurEnabled: Bool {
        get { return !blurEffectView.isHidden }
        set { blurEffectView.isHidden = !newValue }
    }

    /// The style of the blur effect
    public var blurStyle: UIBlurEffect.Style = .light {
        didSet {
            blurEffectView.effect = UIBlurEffect(style: blurStyle)
        }
    }

    /// The opacity of the blur effect: default 0.7
    public var blurOpacity: CGFloat {
        get { return blurEffectView.alpha }
        set { blurEffectView.alpha = newValue }
    }

    /// The background color of the overlay view
    public var color: UIColor? {
        get { return overlay.backgroundColor }
        set { overlay.backgroundColor = newValue }
    }

    /// The opacity of the overlay view: default 0.7
    public var opacity: CGFloat {
        get { return overlay.alpha }
        set { overlay.alpha = newValue }
    }

    /// The enable of the overlay view: default true
    public var enable: Bool = true {
        didSet {
            overlay.isHidden = enable
        }
    }

    // MARK: - Views

    fileprivate lazy var blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.isHidden = true
        view.alpha = 0.7
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.effect = UIBlurEffect(style: blurStyle)
        return view
    }()

    fileprivate lazy var overlay: UIView = {
        let overlay = UIView(frame: .zero)
        overlay.backgroundColor = .black
        overlay.alpha = 0.7
        overlay.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return overlay
    }()

    // MARK: - Inititalizers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    fileprivate func setupView() {
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundColor = .clear
        alpha = 0

        addSubview(blurEffectView)
        addSubview(overlay)
    }

    override public func layoutSubviews() {
        blurEffectView.frame = bounds
    }
}
