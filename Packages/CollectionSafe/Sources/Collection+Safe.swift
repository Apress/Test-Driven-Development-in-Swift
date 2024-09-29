extension Collection {
    /// Returns the element at the specified index if it is within range, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
