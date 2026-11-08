import _Concurrency

extension AsyncSequence {

    @inlinable
    public func compactMap<Output>(
        _ transform: @escaping (Element) -> Output?
    ) -> Async.CompactMap<Self, Output> {
        Async.CompactMap(base: self, transform: .sync(transform))
    }

    @inlinable
    public func compactMap<Output>(
        _ transform: @escaping (Element) async -> Output?
    ) -> Async.CompactMap<Self, Output> {
        Async.CompactMap(base: self, transform: .async(transform))
    }
}

extension AsyncSequence {

    @inlinable
    public func filter(
        _ isIncluded: @escaping (Element) -> Bool
    ) -> Async.Filter<Self> {
        Async.Filter(base: self, predicate: .sync(isIncluded))
    }

    @inlinable
    public func filter(
        _ isIncluded: @escaping (Element) async -> Bool
    ) -> Async.Filter<Self> {
        Async.Filter(base: self, predicate: .async(isIncluded))
    }
}

extension AsyncSequence {

    @inlinable
    public func flatMap<Segment: AsyncSequence>(
        _ transform: @escaping (Element) -> Segment
    ) -> Async.FlatMap<Self, Segment> {
        Async.FlatMap(base: self, transform: .sync(transform))
    }

    @inlinable
    public func flatMap<Segment: AsyncSequence>(
        _ transform: @escaping (Element) async -> Segment
    ) -> Async.FlatMap<Self, Segment> {
        Async.FlatMap(base: self, transform: .async(transform))
    }
}

extension AsyncSequence {

    @inlinable
    public func map<Output>(
        _ transform: @escaping (Element) -> Output
    ) -> Async.Map<Self, Output> {
        Async.Map(base: self, transform: .sync(transform))
    }

    @inlinable
    public func map<Output>(
        _ transform: @escaping (Element) async -> Output
    ) -> Async.Map<Self, Output> {
        Async.Map(base: self, transform: .async(transform))
    }
}
