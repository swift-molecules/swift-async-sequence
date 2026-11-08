import _Concurrency


extension Async.Filter {
    @usableFromInline
    enum Predicate {
        case sync((Base.Element) -> Bool)
        case async((Base.Element) async -> Bool)
    }
}
