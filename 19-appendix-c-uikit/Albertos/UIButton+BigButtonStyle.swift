import UIKit

extension UIButton {

    func applyBigButtonStyle() {
        backgroundColor = .crimson

        let padding = CGFloat(12.0)
        set(.height, to: intrinsicContentSize.height + padding)
        set(.width, to: intrinsicContentSize.width + padding)

        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        layer.cornerRadius = 10
    }
}

class BigButton: UIButton {

    private let padding: CGFloat

    override init(frame: CGRect) {
        self.padding = 6 * 2

        super.init(frame: .zero)

        backgroundColor = .crimson

        let padding = CGFloat(12.0)
        set(.height, to: intrinsicContentSize.height + padding)
        set(.width, to: intrinsicContentSize.width + padding)

        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("This view has no `.xib` backing it. Use `init` instead.")
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        set(.height, to: intrinsicContentSize.height + padding)
        set(.width, to: intrinsicContentSize.width + padding)
    }
}
