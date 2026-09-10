import Async_Sequence
import Async
import Testing

@Suite
struct `Async maps transform values while preserving caller isolation` {

    @Test
    func `Mapping transforms each sequence element`() async {
        let source = Produce([1, 2, 3])

        let mapped = source.map { $0 * 10 }

        var results: [Int] = []
        for await value in mapped {
            results.append(value)
        }

        #expect(results == [10, 20, 30])
    }

    @Test
    func `Mapping transforms the sequence element type`() async {
        let source = Produce([1, 2, 3])

        let mapped = source.map { "value: \($0)" }

        var results: [String] = []
        for await value in mapped {
            results.append(value)
        }

        #expect(results == ["value: 1", "value: 2", "value: 3"])
    }

    @Test
    func `Empty source produces empty output`() async {
        let source = Produce<Int>([])

        let mapped = source.map { $0 * 2 }

        var count = 0
        for await _ in mapped {
            count += 1
        }

        #expect(count == 0)
    }

    @Test
    func `Map chains with filter`() async {
        let source = Produce([1, 2, 3, 4, 5])

        let pipeline =
            source
            .map { $0 * 2 }
            .filter { $0 > 4 }

        var results: [Int] = []
        for await value in pipeline {
            results.append(value)
        }

        #expect(results == [6, 8, 10])
    }

    @Test
    func `Sync closure returns concrete Async.Map type`() async {
        let source = Produce([1, 2, 3])
        let mapped = source.map { $0 * 2 }

        #expect(mapped is Async.Map<Produce<Int>, Int>)
    }

}
