// Initial generic implementation of graph transformations
// This should be more sophisticated with ability to combine
// transformations.
//
// Notes:
//
// - there should be possibility to tell whether the transformation operates on
// the same object or arrow
// - there should be possibility to combine multiple transformations or at
// least to compare them in order to tell which ones are going to be replaced
// by later ones in the ordered list
// - transformation should provide a human readable description of the
// transformation (either through CustomStringConvertible or other means or
// both)
//
/// Wrapper for a graph transformation function.
///
public struct GraphTransform<Reference: Hashable, State, Slot: Hashable> {
    public typealias Graph = ObjectGraph<Reference, State, Slot>

    let transform: (inout Graph) -> Void

    public init(_ transform: @escaping (inout Graph) -> Void) {
        self.transform = transform
    }

    public func apply(_ graph: inout Graph) {
        transform(&graph)
    }
}

// List of graph transformations
public struct GraphTransformList<Reference: Hashable, State, Slot: Hashable>: Collection {
    public typealias Graph = ObjectGraph<Reference, State, Slot>
    public typealias Element = GraphTransform<Reference, State, Slot>
    public typealias Index = Array<Element>.Index

    var transforms: [Element]

    public init() {
        transforms = []
    }

    public init<C>(collection: C) where C: Collection, C.Element == Element {
        transforms = Array(collection)
    }

    /// Apply the transformation to a graph.
    ///
    public func apply(_ graph: inout Graph) {
        for transform in transforms {
            transform.apply(&graph)
        }
    }

    /// Append a tansformation function to the list.
    ///
    mutating public func append(_ transform: @escaping (inout Graph) -> Void) {
        transforms.append(GraphTransform(transform))
    }

    // Collection Conformance
    //
    public var startIndex: Index {
        return transforms.startIndex
    }

    public var endIndex: Index {
        return transforms.endIndex
    }

    public func index(after index: Index) -> Index {
        return transforms.index(after: index)
    }

    public func formIndex(after index: inout Index) {
        transforms.formIndex(after: &index)
    }

    public subscript(position: Index) -> Element {
        return transforms[position]
    }

    public static func + (lhs: GraphTransformList, rhs: GraphTransformList) -> GraphTransformList {
        return GraphTransformList(collection: lhs.transforms + rhs.transforms)
    }
    public static func += (lhs: inout GraphTransformList, rhs: GraphTransformList) {
        lhs.transforms += rhs.transforms
    }

}
