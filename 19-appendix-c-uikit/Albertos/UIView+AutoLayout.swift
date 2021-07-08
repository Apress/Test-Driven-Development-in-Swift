import UIKit

extension UIView {

    func set(
        _ attribute: NSLayoutConstraint.Attribute,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        to constant: Double
    ) {
        set(attribute, relatedBy: relation, to: CGFloat(constant))
    }

    func set(
        _ attribute: NSLayoutConstraint.Attribute,
        relatedBy relation: NSLayoutConstraint.Relation = .equal,
        to constant: CGFloat
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false

        let matchesConstraint: (NSLayoutConstraint) -> Bool = {
            $0.relation == relation
                && $0.firstAttribute == attribute
                && ($0.firstItem as? UIView) == self
        }
        constraints.filter(matchesConstraint).forEach { removeConstraint($0) }

        addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .equal,
                toItem: .none,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: constant
            )
        )
    }

    func fill(_ superview: UIView) {
        pin([.topMargin, .leftMargin, .bottomMargin, .rightMargin], to: superview)
    }

    func pin(
        _ attribute: NSLayoutConstraint.Attribute,
        to view: UIView,
        padding: Double = 0
    ) {
        pin([attribute], to: view, padding: padding)
    }
    
    func pin(
        _ attributes: [NSLayoutConstraint.Attribute],
        to view: UIView,
        padding: Double = 0
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints(
            attributes.map {
                NSLayoutConstraint(
                    item: self,
                    attribute: $0,
                    relatedBy: .equal,
                    toItem: view,
                    attribute: $0,
                    multiplier: 1,
                    constant: CGFloat(padding)
                )
            }
        )
    }

    func alignSafeAreaTopAnchor(to view: UIView) {
        align(topAnchor, with: view.safeAreaLayoutGuide.topAnchor)
    }

    func alignSafeAreaBottomAnchor(to view: UIView) {
        align(bottomAnchor, with: view.safeAreaLayoutGuide.bottomAnchor)
    }

    private func align(_ anchor: NSLayoutYAxisAnchor, with anchorToAlightWith: NSLayoutYAxisAnchor) {
        NSLayoutConstraint.activate(
            [
                anchorToAlightWith.constraint(
                    equalToSystemSpacingBelow: anchor,
                    multiplier: 0
                )
            ]
        )
    }
}
