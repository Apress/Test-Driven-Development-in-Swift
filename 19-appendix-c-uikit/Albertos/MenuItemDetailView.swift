import UIKit

class MenuItemDetailView: UIStackView {
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    private(set) lazy var spicyLabel = UILabel()
    let addOrRemoveFromOrderButton: UIButton = .init(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = 8
    }

    @available(*, unavailable, message: "This view has no `.xib` backing it. Use `init(frame:)` instead.")
    required init(coder _: NSCoder) {
        fatalError("This view has no `.xib` backing it. Use `init(frame:)` instead.")
    }

    func configureContent(with viewModel: MenuItemDetailViewModel) {
        nameLabel.text = viewModel.name
        addArrangedSubview(nameLabel)

        if let spicy = viewModel.spicy {
            spicyLabel.text = spicy
            spicyLabel.font = spicyLabel.font.adding(.traitItalic)
            addArrangedSubview(spicyLabel)
        }

        priceLabel.text = viewModel.price
        addArrangedSubview(priceLabel)

        addOrRemoveFromOrderButton.setTitle(viewModel.addOrRemoveFromOrderButtonText, for: .normal)
        addArrangedSubview(addOrRemoveFromOrderButton)
    }
}
