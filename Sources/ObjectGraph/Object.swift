/// Representation of an extracted object from the graph.
///
/// Note: This structure does not necessarily have to reflect how the objects
/// are stored in the graph.
public struct Object<Reference: Hashable, State, Slot: Hashable>: CustomStringConvertible {
    public typealias Slots = Dictionary<Slot, Reference>.Keys

    public let reference: Reference
    public let state: State
    public let references: [Slot:Reference]

    public init(reference: Reference, state: State, references: [Slot:Reference]) {
        self.reference = reference
        self.state = state
        self.references = references
    }

    public var description: String {
        let referencesDesc = references.map {
            "\($0.key)->\($0.value)"
        }.joined(separator: ",")

        return "\(reference){\(state); \(referencesDesc)}"
    }
}
