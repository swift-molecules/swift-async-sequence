# swift-async-sequence

Use this package when you transform an `AsyncSequence` with `map`, `filter`, `compactMap` or `flatMap` and the closures must run in the caller's isolation, for example on the `MainActor`. The standard library's `AsyncMapSequence` does not guarantee that. Importing `Async Sequence` makes these four operators return `Async.Map<Base, Output>`, `Async.Filter<Base>`, `Async.CompactMap<Base, Output>` and `Async.FlatMap<Base, Segment>` in place of the standard library's adaptors. Chains keep their concrete nested types, with no type erasure. To erase a sequence to one type, use `Async.Stream` from the sibling package swift-async-stream. The operators from this package also apply to it.

## Laws

- A synchronous transform or predicate runs in the isolation of the `next(isolation:)` call. When the loop runs on the `MainActor`, every closure in the chain runs on the `MainActor`.
- The operators are lazy and buffer nothing. Each `next` pulls from the base only until it can return one element, and the closure runs on each pulled element.
- Element order is kept. `Async.FlatMap` reads one segment to its end before it pulls the next base element, so segments never interleave.
- Every operator is non-throwing. When the base sequence throws, the error is discarded and that `next` returns `nil`, which ends a `for await` loop. Elements produced before the failure are kept.
- When a segment of `Async.FlatMap` throws, the rest of that segment is skipped and iteration continues with the next base element. Only a failure of the outer sequence ends the iteration.
- The operators never check for cancellation themselves. Cancellation affects them only through the base sequence and the closures.
