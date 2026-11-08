import _Concurrency

extension Async.CompactMap {
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
    }
}

extension Async.CompactMap.Iterator {
    @inlinable
    public mutating func next(

        isolation actor: isolated (any Actor)? = #isolation
    ) async -> Output? {
        while true {
            let element: Base.Element?
            do throws(Base.Failure) {
                element = try await baseIterator.next(isolation: actor)
            } catch {
                return nil
            }
            guard let element else { return nil }
            let result: Output?
            switch transform {
            case .sync(let f): result = f(element)
            case .async(let f): result = await f(element)
            }
            if let output = result {
                return output
            }
        }
    }
}
