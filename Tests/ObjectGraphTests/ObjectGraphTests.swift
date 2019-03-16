import XCTest
@testable import ObjectGraph

final class GraphTests: XCTestCase {
    func testInsertNode() {
        let g = ObjectGraph<Int,Int>()

        g.insert(10)
        g.insert(20)
        XCTAssertEqual(g.nodes.count, 2)
        g.insert(10)
        XCTAssertEqual(g.nodes.count, 2)
    }

    func testConnect() {
        let g = ObjectGraph<Int,Int>()

        g.insert(1)
        g.insert(2)
        g.insert(3)
        g.insert(4)
        g.insert(5)
        g.insert(6)

        XCTAssertEqual(g.nodes.count, 6)

        g.connect(1, to: 2, at: 12)
        g.connect(1, to: 3, at: 13)
        XCTAssertEqual(g.slotCount, 2)

        g.connect(1, to: 4, at: 14)
        XCTAssertEqual(g.slotCount, 3)
        g.connect(5, to: 6, at: 56)
        XCTAssertEqual(g.slotCount, 4)
    }
    func testHeads() {
        let g = ObjectGraph<Int,Int>()

        XCTAssertNil(g.targets(1))
        g.insert(1)
        XCTAssertEqual(g.targets(1)?.count, 0)

        g.insert(2)
        g.insert(3)
        g.connect(1, to: 2, at: 12)
        g.connect(1, to: 3, at: 13)
        g.connect(2, to: 1, at: 13)

        XCTAssertEqual(g.targets(1)?.count, 2)

        g.disconnect(1, at: 12)
        XCTAssertEqual(g.targets(1)?.count, 1)

        g.disconnect(1, at: 13)
        XCTAssertEqual(g.targets(1)?.count, 0)
    }
}
