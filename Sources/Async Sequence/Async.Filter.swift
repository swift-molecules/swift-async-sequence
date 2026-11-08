import _Concurrency

extension Async {
    public struct Filter<Base: AsyncSequence>: AsyncSequence {
        @usableFromInline
        let base: Base

        @usableFromInline
        let predicate: Predicate

        @usableFromInline
        init(base: Base, predicate: Predicate) {
            self.base = base
            self.predicate = predicate
        }
    }
}

extension Async.Filter {
    public typealias Element = Base.Element


}

extension Async.Filter {
    @inlinable
    public func makeAsyncIterator() -> Iterator {
        Iterator(baseIterator: base.makeAsyncIterator(), predicate: predicate)
    }
}
