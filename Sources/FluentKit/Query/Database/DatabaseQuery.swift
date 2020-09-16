public struct DatabaseQuery {
    public var schema: String
    public var customIDKey: FieldKey?
    public var isUnique: Bool
    public var fields: [Field]
    public var childAggregates: [ChildAggregateField]
    public var action: Action
    public var filters: [Filter]
    public var input: [Value]
    public var joins: [Join]
    public var sorts: [Sort]
    public var limits: [Limit]
    public var offsets: [Offset]

    init(schema: String) {
        self.schema = schema
        self.isUnique = false
        self.fields = []
        self.childAggregates = []
        self.action = .read
        self.filters = []
        self.input = []
        self.joins = []
        self.sorts = []
        self.limits = []
        self.offsets = []
    }
}

extension DatabaseQuery: CustomStringConvertible {
    public var description: String {
        var parts = [
            "query",
            "\(self.action)",
            self.schema
        ]
        if self.isUnique {
            parts.append("unique")
        }
        if !self.fields.isEmpty {
            parts.append("fields=\(self.fields)")
        }
        if !self.childAggregates.isEmpty {
            parts.append("fields=\(self.childAggregates)")
        }
        if !self.filters.isEmpty {
            parts.append("filters=\(self.filters)")
        }
        if !self.input.isEmpty {
            parts.append("input=\(self.input)")
        }
        if !self.limits.isEmpty {
            parts.append("limits=\(self.limits)")
        }
        if !self.offsets.isEmpty {
            parts.append("offsets=\(self.offsets)")
        }
        return parts.joined(separator: " ")
    }
}
