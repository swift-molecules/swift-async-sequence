import _Concurrency

extension Async {
    public struct CompactMap<Base: AsyncSequence, Output>: AsyncSequence {
        @usableFromInline
        let base: Base

        @usableFromInline
        let transform: Transform

        @usableFromInline
        init(base: Base, transform: Transform) {
            self.base = base
            self.transform = transform
        }
    }
}

extension Async.CompactMap {
    public typealias Element = Output


}

extension Async.CompactMap {
    @inlinable
    public func makeAsyncIterator() -> Iterator {
        Iterator(baseIterator: base.makeAsyncIterator(), transform: transform)
    }
}
