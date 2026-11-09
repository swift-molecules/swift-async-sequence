import Async_Sequence
import Testing

enum `Async.Sequence.Failure Tests` {}

extension `Async.Sequence.Failure Tests` {
    @Suite
    struct `Async sequence operators preserve their nonthrowing failure behavior` {
        @Test
        func `Map ends iteration when the upstream sequence fails`() async {
            let source = FailingSequence(steps: [.value(1), .failure, .value(3)])
            let mapped: Async.Map<FailingSequence, Int> = source.map { $0 * 10 }
            var values: [Int] = []

            for await value in mapped {
                values.append(value)
            }

            #expect(values == [10])
        }

        @Test
        func `Filter ends iteration when the upstream sequence fails`() async {
            let source = FailingSequence(steps: [.value(1), .failure, .value(3)])
            let filtered: Async.Filter<FailingSequence> = source.filter { $0 > 0 }
            var values: [Int] = []

            for await value in filtered {
                values.append(value)
            }

            #expect(values == [1])
        }

        @Test
        func `CompactMap ends iteration when the upstream sequence fails`() async {
            let source = FailingSequence(steps: [.value(1), .failure, .value(3)])
            let mapped: Async.CompactMap<FailingSequence, String> = source.compactMap {
                String($0)
            }
            var values: [String] = []

            for await value in mapped {
                values.append(value)
            }

            #expect(values == ["1"])
        }

        @Test
        func `FlatMap ends iteration when its outer sequence fails`() async {
            let source = FailingSequence(steps: [.value(1), .failure, .value(3)])
            let mapped: Async.FlatMap<FailingSequence, Produce<Int>> = source.flatMap {
                Produce([$0 * 10, $0 * 10 + 1])
            }
            var values: [Int] = []

            for await value in mapped {
                values.append(value)
            }

            #expect(values == [10, 11])
        }

        @Test
        func `FlatMap skips the rest of a failing inner sequence and continues with the next segment`() async {
            let source = Produce([1, 2])
            let mapped: Async.FlatMap<Produce<Int>, FailingSequence> = source.flatMap {
                FailingSequence(steps: [.value($0 * 10), .failure, .value($0 * 10 + 1)])
            }
            var values: [Int] = []

            for await value in mapped {
                values.append(value)
            }

            #expect(values == [10, 20])
        }
    }

    @Suite
    struct `Async sequence operators stay finished after a swallowed failure` {
        @Test
        func `Map returns nil on every call after the upstream sequence fails`() async {
            let source = FailingSequence(steps: [.value(1), .failure, .value(3)])
            var iterator = source.map { $0 * 10 }.makeAsyncIterator()

            #expect(await iterator.next() == 10)
            #expect(await iterator.next() == nil)
            #expect(await iterator.next() == nil)
        }

        @Test
        func `Filter returns nil on every call after the upstream sequence fails`() async {
            let source = FailingSequence(steps: [.value(1), .failure, .value(3)])
            var iterator = source.filter { $0 > 0 }.makeAsyncIterator()

            #expect(await iterator.next() == 1)
            #expect(await iterator.next() == nil)
            #expect(await iterator.next() == nil)
        }

        @Test
        func `CompactMap returns nil on every call after the upstream sequence fails`() async {
            let source = FailingSequence(steps: [.value(1), .failure, .value(3)])
            var iterator = source.compactMap { String($0) }.makeAsyncIterator()

            #expect(await iterator.next() == "1")
            #expect(await iterator.next() == nil)
            #expect(await iterator.next() == nil)
        }

        @Test
        func `FlatMap returns nil on every call after its outer sequence fails`() async {
            let source = FailingSequence(steps: [.value(1), .failure, .value(3)])
            var iterator = source.flatMap { Produce([$0 * 10]) }.makeAsyncIterator()

            #expect(await iterator.next() == 10)
            #expect(await iterator.next() == nil)
            #expect(await iterator.next() == nil)
        }
    }
}

private struct FailingSequence: AsyncSequence {
    typealias Element = Int

    enum Error: Swift::Error {
        case upstream
    }

    enum Step {
        case value(Int)
        case failure
    }

    let steps: [Step]

    struct Iterator: AsyncIteratorProtocol {
        var steps: IndexingIterator<[Step]>

        mutating func next(
            isolation actor: isolated (any Actor)? = #isolation
        ) async throws(Error) -> Int? {
            switch steps.next() {
            case .some(.value(let value)): return value
            case .some(.failure): throw .upstream
            case nil: return nil
            }
        }
    }
}

extension FailingSequence {
    func makeAsyncIterator() -> Iterator {
        Iterator(steps: steps.makeIterator())
    }
}
