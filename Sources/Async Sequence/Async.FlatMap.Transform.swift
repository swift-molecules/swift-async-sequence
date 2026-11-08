import _Concurrency


extension Async.FlatMap {
    @usableFromInline
    enum Transform {
        case sync((Base.Element) -> Segment)
        case async((Base.Element) async -> Segment)
    }
}
