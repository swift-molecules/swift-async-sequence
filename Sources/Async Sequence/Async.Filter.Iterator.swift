import _Concurrency


extension Async.Filter {
    public struct Iterator: AsyncIteratorProtocol {
        @usableFromInline
        var baseIterator: Base.AsyncIterator

        @usableFromInline
        let predicate: Predicate

        @usableFromInline
        init(
            baseIterator: Base.AsyncIterator,
            predicate: Predicate
        ) {
            self.baseIterator = baseIterator
            self.predicate = predicate
        }

        @inlinable
        public mutating func next(

            isolation actor: isolated (any Actor)? = #isolation
        ) async -> Base.Element? {
            while true {
                let element: Base.Element?
                do throws(Base.Failure) {
                    element = try await baseIterator.next(isolation: actor)
                } catch {
                    return nil
                }
                guard let element else { return nil }
                let included: Bool
                switch predicate {
                case .sync(let f): included = f(element)
                case .async(let f): included = await f(element)
                }
                if included {
                    return element
                }
            }
        }
    }
}
