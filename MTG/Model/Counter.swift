enum CounterType: String {
    case health = "Health"
    case toxic = "Toxic"
    case commander = "Commander"
}

struct Counter {
    var value: Int
    let type: CounterType
}
