public class ObjectGraph<O:Hashable, S:Hashable> {
    /// Node in the object graph.
    public typealias Object = O

    /// Label of a reference to another object.
    public typealias Slot = S

    public struct Node {
        var slots: [Slot:Object] = [:]
    }

    var nodes: [Object:Node]

    /// Create an empty graph
    public init() {
        nodes = [:]
    }

    public var objects: AnyCollection<Object> {
        return AnyCollection(nodes.keys)
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
    public func insert(_ object: Object) {
        guard nodes[object] == nil else {
            return
        }
        nodes[object] = Node()
    }

    /// Inserts an edge to a graph. 
    ///
    /// - Precondition: `object` and `target` must exist in the object graph.
    public func connect(_ origin: Object, to target: Object, at slot: Slot) {
        precondition(nodes[origin] != nil, "Graph has no origin object: \(origin)")
        precondition(nodes[target] != nil, "Graph has no target object: \(target)")

        nodes[origin]!.slots[slot] = target
    }

    /// Removes an edge from the graph.
    ///
    /// - Precondition: `object` must exist.
    public func disconnect(_ origin: Object, at slot: Slot) {
        precondition(nodes[origin] != nil)

        nodes[origin]!.slots[slot] = nil
    }

    /// Returns heads of arrows originating in `tail` as a mapping of labels to
    /// head nodes. 
    ///
    public func slots(_ origin: Object) -> [Slot] {
        guard let node = nodes[origin] else {
            return []
        }

        return Array(node.slots.keys)
    }

    /// Get a target node of an edge originating in node `from` through edge
    /// label `label.
    ///`
    public func target(_ origin: Object, at slot:Slot) -> Object? {
        guard let node = nodes[origin] else {
            return nil
        }
        return node.slots[slot]
    }

    /// Get all target nodes of an edge originating in node `from`.
    ///`
    public func targets(_ origin: Object) -> [(Slot, Object)]? {
        guard let node = nodes[origin] else {
            return nil
        }
        return node.slots.map { ($0.key, $0.value) }
    }

    // TODO: Union
    // TODO: Intersection
    // TODO: Replace object
    // TODO: Split object
    // TODO: Merge object
}
