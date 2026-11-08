import _Concurrency


extension Async.FlatMap {
    public struct Iterator: AsyncIteratorProtocol {
        @usableFromInline
        var baseIterator: Base.AsyncIterator

        @usableFromInline
        let transform: Transform

        @usableFromInline
        var currentIterator: Segment.AsyncIterator?

        @usableFromInline
        init(
            baseIterator: Base.AsyncIterator,
            transform: Transform
        ) {
            self.baseIterator = baseIterator
            self.transform = transform
            self.currentIterator = nil
        }

        @inlinable
        public mutating func next(

            isolation actor: isolated (any Actor)? = #isolation
        ) async -> Segment.Element? {
            while true {
                if var inner = currentIterator {
                    let element: Segment.Element?
                    do throws(Segment.Failure) {
                        element = try await inner.next(isolation: actor)
                    } catch {
                        element = nil
                    }
                    if let element {
                        currentIterator = inner
                        return element
                    }
                    currentIterator = nil
                }

                let base: Base.Element?
                do throws(Base.Failure) {
                    base = try await baseIterator.next(isolation: actor)
                } catch {
                    return nil
                }
                guard let base else {
                    return nil
                }

                let segment: Segment
                switch transform {
                case .sync(let f): segment = f(base)
                case .async(let f): segment = await f(base)
                }
                currentIterator = segment.makeAsyncIterator()
            }
        }
    }
}
