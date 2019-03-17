extension ObjectGraph {
    // Initial generic implementation of graph transformations
    // This should be more sophisticated with ability to combine
    // transformations.
    public struct TransformList: Collection {
        public typealias Element = Transform
        public typealias Index = Array<Transform>.Index

        var transforms: [Transform]

        public init() {
            transforms = []
        }

        public init<C>(collection: C) where C: Collection, C.Element == Transform {
            transforms = Array(collection)
        }

        /// Apply the transformation to a graph.
        ///
        public func apply(_ graph: inout ObjectGraph){
            for transform in transforms {
                transform.apply(&graph)
            }
        }

        /// Append a tansformation function to the list.
        ///
        mutating public func append(_ transform: @escaping (inout ObjectGraph) -> Void) {
            transforms.append(Transform(transform))
        }

        // Collection Conformance
        //
        public var startIndex: Index {
            return transforms.startIndex
        }

        public var endIndex: Index {
            return transforms.endIndex
        }

        public func index(after i: Index) -> Index {
            return transforms.index(after: i)
        }

        public func formIndex(after i: inout Index) {
            transforms.formIndex(after: &i)
        }

        public subscript(position: Index) -> Element {
            return transforms[position]
        }

        public static func + (lhs: TransformList, rhs: TransformList) -> TransformList {
            return TransformList(collection: lhs.transforms + rhs.transforms)
        }
        public static func += (lhs: inout TransformList, rhs: TransformList) {
            lhs.transforms += rhs.transforms
        }

    }
    public struct Transform {
        let transform: (inout ObjectGraph) -> Void

        public init(_ transform: @escaping (inout ObjectGraph) -> Void) {
            self.transform = transform
        }

        public func apply(_ graph: inout ObjectGraph){
            transform(&graph)
        }
    }
}
