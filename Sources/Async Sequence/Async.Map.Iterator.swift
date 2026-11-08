import _Concurrency


extension Async.Map {
    public struct Iterator: AsyncIteratorProtocol {
        @usableFromInline
        var baseIterator: Base.AsyncIterator

        @usableFromInline
        let transform: Transform

        @usableFromInline
        init(
            baseIterator: Base.AsyncIterator,
            transform: Transform
        ) {
            self.baseIterator = baseIterator
            self.transform = transform
        }

        @inlinable
        public mutating func next(

            isolation actor: isolated (any Actor)? = #isolation
        ) async -> Output? {
            let element: Base.Element?
            do throws(Base.Failure) {
                element = try await baseIterator.next(isolation: actor)
            } catch {
                return nil
            }
            guard let element else {
                return nil
            }
            switch transform {
            case .sync(let f): return f(element)
            case .async(let f): return await f(element)
            }
        }
    }
}
