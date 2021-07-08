import UIKit

class UITableViewFooterLabel: UIView {

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var textAlignment: NSTextAlignment {
        get { label.textAlignment }
        set { label.textAlignment = newValue }
    }

    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }

    private let label = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)

        label.numberOfLines = 0
        label.fill(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This view has no `.xib` backing it. Use `init` instead.")
    }
}
