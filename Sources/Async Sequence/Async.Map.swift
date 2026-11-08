import _Concurrency

extension Async {
    public struct Map<Base: AsyncSequence, Output>: AsyncSequence {
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

extension Async.Map {
    public typealias Element = Output


}

extension Async.Map {
    @inlinable
    public func makeAsyncIterator() -> Iterator {
        Iterator(baseIterator: base.makeAsyncIterator(), transform: transform)
    }
}
