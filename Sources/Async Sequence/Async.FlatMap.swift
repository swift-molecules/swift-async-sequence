import _Concurrency

extension Async {
    public struct FlatMap<Base: AsyncSequence, Segment: AsyncSequence>: AsyncSequence {
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

extension Async.FlatMap {
    public typealias Element = Segment.Element


}

extension Async.FlatMap {
    @inlinable
    public func makeAsyncIterator() -> Iterator {
        Iterator(baseIterator: base.makeAsyncIterator(), transform: transform)
    }
}
