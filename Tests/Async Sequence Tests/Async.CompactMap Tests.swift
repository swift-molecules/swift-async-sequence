import Async_Sequence
import Async
import Testing

@Suite
struct `Async compact maps preserve transformed values and caller isolation` {

    @Test
    func `Transforms and discards nil`() async {
        let source = Produce(["1", "two", "3", "four", "5"])

        let compacted = source.compactMap { Int($0) }

        var results: [Int] = []
        for await value in compacted {
            results.append(value)
        }

        #expect(results == [1, 3, 5])
    }

    @Test
    func `All nil produces empty output`() async {
        let source = Produce(["a", "b", "c"])

        let compacted = source.compactMap { Int($0) }

        var count = 0
        for await _ in compacted {
            count += 1
        }

        #expect(count == 0)
    }

    @Test
    func `No nil keeps all elements`() async {
        let source = Produce([1, 2, 3])

        let compacted = source.compactMap { Optional($0 * 10) }

        var results: [Int] = []
        for await value in compacted {
            results.append(value)
        }

        #expect(results == [10, 20, 30])
    }

    @Test
    func `Empty source produces empty output`() async {
        let source = Produce<String>([])

        let compacted = source.compactMap { Int($0) }

        var count = 0
        for await _ in compacted {
            count += 1
        }

        #expect(count == 0)
    }

    @Test
    func `CompactMap chains with map`() async {
        let source = Produce(["1", "two", "3"])

        let pipeline =
            source
            .compactMap { Int($0) }
            .map { $0 * 100 }

        var results: [Int] = []
        for await value in pipeline {
            results.append(value)
        }

        #expect(results == [100, 300])
    }

    @Test
    func `Sync closure returns concrete Async.CompactMap type`() async {
        let source = Produce(["1", "two", "3"])
        let compacted = source.compactMap { Int($0) }

        #expect(compacted is Async.CompactMap<Produce<String>, Int>)
    }

}
