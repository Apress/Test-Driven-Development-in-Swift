import UIKit

extension UIFont {

    func adding(_ trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let fontDescriptor = fontDescriptor.withSymbolicTraits(trait) else {
            return self
        }

        // size = 0 means "keep the current size"
        return UIFont(descriptor: fontDescriptor, size: 0)
    }
}
