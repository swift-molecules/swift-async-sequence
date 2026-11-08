import _Concurrency


extension Async.CompactMap {
    @usableFromInline
    enum Transform {
        case sync((Base.Element) -> Output?)
        case async((Base.Element) async -> Output?)
    }
}
