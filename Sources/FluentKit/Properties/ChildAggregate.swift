//
//  ChildAggregate.swift
//
//
//  Created by Bruce Quinton on 16/9/20.
//
//AggregiateFields (Always optional)
extension  Model {
    public typealias AggregiateField<Value> = AggregiateFieldProperty<Self, Value>
        where Value: Codable
}

// MARK: Type

@propertyWrapper
public final class AggregiateFieldProperty<From, WrappedValue>
    where From: FluentKit.Model, WrappedValue: Codable
{
  public let foregintable: String
  public let method: DatabaseQuery.ChildAggregateField.Method
  public let field: FieldKey
  public let local: FieldKey
  public let childfield: FieldKey
  
  var outputValue: WrappedValue??
  var inputValue: DatabaseQuery.Value?

//  var ColumnFieldKey: FieldKey?
//  public let ParentColumn: ParentColumnKey?

  public var projectedValue: AggregiateFieldProperty<From, WrappedValue> {
      self
  }

  public var wrappedValue: WrappedValue? {
    get {
      self.value ?? nil
    }
    set {
      fatalError("AggregiateFieldProperty relation is get-only.")
    }
  }
  
//  _ foreign: Foreign.Type,
//  on filter: JoinFilter<Foreign, Local, Value>,
//  method: DatabaseQuery.Join.Method = .inner
  public init(foreigntable: String, method: DatabaseQuery.ChildAggregateField.Method, field: FieldKey, local: FieldKey, childfield: FieldKey) {
    self.foregintable = foreigntable
    self.field = field
    self.local = local
    self.childfield = childfield
    self.method = method
    
  }

}

// MARK: Property

extension AggregiateFieldProperty: AnyProperty { }

extension AggregiateFieldProperty: Property {
      public typealias Model = From
      public typealias Value = WrappedValue?

  public var value: WrappedValue?? {
        get {
            if let value = self.inputValue {
                switch value {
                case .bind(let bind):
                    return .some(bind as? WrappedValue)
                case .enumCase(let string):
                    return .some(string as? WrappedValue)
                case .default:
                    fatalError("Cannot access default field for '\(Model.self).\(local)' before it is initialized or fetched")
                case .null:
                    return nil
                default:
                    fatalError("Unexpected input value type for '\(Model.self).\(local)': \(value)")
                }
            } else if let value = self.outputValue {
                return .some(value)
            } else {
                return .none
            }
        }
        set {

            if let value = newValue {
                self.inputValue = value.flatMap { .bind($0) } ?? .null
            } else {
                self.inputValue = nil
            }
        }
    }
}

// MARK: Queryable

extension AggregiateFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] {
        []
    }
}

extension AggregiateFieldProperty: QueryableProperty { }

// MARK: Database
extension AggregiateFieldProperty: AggregateDatabaseProperty {
  public var aggregates: [DatabaseQuery.ChildAggregateField] {
    [DatabaseQuery.ChildAggregateField.ChildAggregate(schema: From.schemaOrAlias, subschema: self.foregintable, method: self.method, field: self.field, foreign: self.childfield, local: self.local)]
  }

    public func input(to input: DatabaseInput) {
        if let inputValue = self.inputValue {
            input.set(inputValue, at: self.local)
        }
    }

    public func output(from output: DatabaseOutput) throws {
        if output.contains(self.field) {
            self.inputValue = nil
            do {
                if try output.decodeNil(self.field) {
                    self.outputValue = .some(nil)
                } else {
                    self.outputValue = try .some(output.decode(self.field, as: Value.self))
                }
            } catch {
                throw FluentError.invalidField(
                    name: self.field.description,
                    valueType: Value.self,
                    error: error
                )
            }
        }
    }
}

// MARK: Codable

extension AggregiateFieldProperty: AnyCodableProperty {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }

    public func decode(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = nil
        } else {
            self.value = try container.decode(Value.self)
        }
    }
}
