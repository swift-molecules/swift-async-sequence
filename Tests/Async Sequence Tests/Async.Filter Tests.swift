import Async_Sequence
import Async
import Testing

@Suite
struct `Async filters preserve matching values and caller isolation` {

    @Test
    func `Filtering includes the matching sequence elements`() async {
        let source = Produce([1, 2, 3, 4, 5])

        let filtered = source.filter { $0 > 3 }

        var results: [Int] = []
        for await value in filtered {
            results.append(value)
        }

        #expect(results == [4, 5])
    }

    @Test
    func `Excludes all when none match`() async {
        let source = Produce([1, 2, 3])

        let filtered = source.filter { $0 > 100 }

        var count = 0
        for await _ in filtered {
            count += 1
        }

        #expect(count == 0)
    }

    @Test
    func `Includes all when all match`() async {
        let source = Produce([1, 2, 3])

        let filtered = source.filter { _ in true }

        var results: [Int] = []
        for await value in filtered {
            results.append(value)
        }

        #expect(results == [1, 2, 3])
    }

    @Test
    func `Empty source produces empty output`() async {
        let source = Produce<Int>([])

        let filtered = source.filter { _ in true }

        var count = 0
        for await _ in filtered {
            count += 1
        }

        #expect(count == 0)
    }

    @Test
    func `Filtering preserves sequence element order`() async {
        let source = Produce([5, 3, 1, 4, 2])

        let filtered = source.filter { $0 % 2 != 0 }

        var results: [Int] = []
        for await value in filtered {
            results.append(value)
        }

        #expect(results == [5, 3, 1])
    }

    @Test
    func `Sync closure returns concrete Async.Filter type`() async {
        let source = Produce([1, 2, 3])
        let filtered = source.filter { $0 > 1 }

        #expect(filtered is Async.Filter<Produce<Int>>)
    }

}
