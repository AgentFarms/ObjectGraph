# ObjectGraph

Simple object graph and it's manipulation library.

Core concept is a graph structure where nodes are objects and edges are
labelled references between objects. We call the label type a `slot`. Slots are
expected to be unique within an object although they might not be unique within
the graph. Edges are uniquely identified by a tuple `(object, slot)`.

Definition: `ObjectGraph<O:Hashable, S:Hashable>` where `O` is object type and
`S` is slot type - reference label..

Example:

```
    let graph = ObjectGraph<Int,String>
    
    graph.insert(10)
    graph.insert(20)
    graph.insert(30)
    graph.insert(40)

    graph.connect(10, to: 20, at: "next")
    graph.connect(20, to: 30, at: "next")
    graph.connect(30, to: 40, at: "next")
```

----

License: MIT
Author: Stefan Urbanek <stefan.urbanek@gmail.com>

