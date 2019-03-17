/// Object graph is a labelled directed multi graph structure. The vertices of
/// the graph are called _objects_ and are referred to by a _reference_. Each
/// object has associated a state. The structure without edges can be
/// considered a map where keys are references and values are object states.
/// The arrows (directed edges) of the graph are represented by _slots_
/// (labels) of edges originating in an object. _Slots_ are unique within
/// originating object, they don't have to be unique in the whole graph. Unique
/// arrow representation in the graph is a tuple of type `(Reference, Slot)`.
///
public struct ObjectGraph<Reference: Hashable, State, Slot:Hashable> {
    // This is not quite public, but we need it for other typealiases.
    public struct Node {
        var state: State
        var slots: [Slot:Reference]

        init(state: State) {
            self.state = state
            self.slots = [:]
        }
    }

    var nodes: [Reference:Node]

    /// Representation of an object from the object graph.
    ///
    public struct Object: CustomStringConvertible {
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

    public typealias References = Dictionary<Reference, Node>.Keys

    public var references: References {
        return nodes.keys
    }

    public struct Objects: Collection {
        public typealias Element = Object
        public typealias Index = Dictionary<Reference, Node>.Index

        var graph: ObjectGraph

        init(_ graph: ObjectGraph) {
            self.graph = graph
        }

        // Collection Conformance
        //
        public var startIndex: Index {
            return graph.nodes.startIndex
        }

        public var endIndex: Index {
            return graph.nodes.endIndex
        }

        public func index(after i: Index) -> Index {
            return graph.nodes.index(after: i)
        }

        public func formIndex(after i: inout Index) {
            graph.nodes.formIndex(after: &i)
        }

        public subscript(position: Index) -> Element {
            let (reference, node) = graph.nodes[position]
            return Object(reference: reference,
                          state: node.state,
                          references: node.slots)
        }
    }

    /// Get an object representation by an object reference.
    public subscript(reference: Reference) -> State? {
        get {
            return nodes[reference]?.state
        }
    }

    public mutating func updateState(_ newValue: State, of reference: Reference) {
        assert(nodes[reference] != nil, "Reference \(reference) not in graph")
        nodes[reference]!.state = newValue
    }

    /// Create an empty graph
    public init() {
        nodes = [:]
    }

    public var objects: Objects {
        return Objects(self)
    }

    /// Total number of slots (edges) in the object graph
    public var slotCount: Int {
        return nodes.reduce(0) { result, item in
            result + item.value.slots.count
        }
    }

    // Mutating functions
    //
    /// Insert an object to the object graph.
    public mutating func insert(_ object: Reference, state: State) {
        guard nodes[object] == nil else {
            return
        }
        nodes[object] = Node(state: state)
    }

    /// Inserts an edge to a graph. 
    ///
    /// - Precondition: `object` and `target` must exist in the object graph.
    public mutating func connect(_ origin: Reference, to target: Reference, at slot: Slot) {
        precondition(nodes[origin] != nil, "Graph has no origin object: \(origin)")
        precondition(nodes[target] != nil, "Graph has no target object: \(target)")

        nodes[origin]!.slots[slot] = target
    }

    /// Removes an edge from the graph.
    ///
    /// - Precondition: `object` must exist.
    public mutating func disconnect(_ origin: Reference, at slot: Slot) {
        precondition(nodes[origin] != nil)

        nodes[origin]!.slots[slot] = nil
    }

    /// Returns heads of arrows originating in `tail` as a mapping of labels to
    /// head nodes. 
    ///
    public func slots(_ origin: Reference) -> [Slot] {
        guard let node = nodes[origin] else {
            return []
        }

        return Array(node.slots.keys)
    }

    /// Get a target node of an edge originating in node `from` through edge
    /// label `label.
    ///`
    public func target(_ origin: Reference, at slot:Slot) -> Reference? {
        guard let node = nodes[origin] else {
            return nil
        }
        return node.slots[slot]
    }

    /// Get all target nodes of an edge originating in node `from`.
    ///
    public func targets(_ origin: Reference) -> [Slot:Reference]? {
        guard let node = nodes[origin] else {
            return nil
        }
        return node.slots
    }

    // TODO: Union
    // TODO: Intersection
    // TODO: Replace object
    // TODO: Split object
    // TODO: Merge object
}
