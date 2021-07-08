import UIKit

class HippoPaymentsConfirmationViewController: UIViewController {

    let dismissButton = UIButton()
    let textLabel = UILabel()
    let container = UIStackView()

    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        isModalInPresentation = true

        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

        view.addConstraints(
            [.topMargin, .leftMargin, .bottomMargin, .rightMargin].map {
                NSLayoutConstraint(
                    item: container,
                    attribute: $0,
                    relatedBy: .equal,
                    toItem: view,
                    attribute: $0,
                    multiplier: 1,
                    constant: 0
                )
            }
        )

        container.addArrangedSubview(textLabel)
        container.addArrangedSubview(dismissButton)
        container.axis = .vertical

        textLabel.text = "Your payment was successful\n\nPowered by HippoPayments 🦛"
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.setTitleColor(.systemBlue, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTouched), for: .primaryActionTriggered)
    }

    @objc
    func dismissButtonTouched() {
        viewControllerPresentationSource.dismiss(animated: true, completion: onDismiss)
    }
}
