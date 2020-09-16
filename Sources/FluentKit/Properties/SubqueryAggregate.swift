//
//  SubqueryAggregate.swift
//  
//
//  Created by Bruce Quinton on 16/9/20.
//
public final class SubqueryAggregate {
  var schema: String
  var alias: String?
  var method: DatabaseQuery.ChildAggregateField.Method
  var field: FieldKey
  var foreign: FieldKey
  var local: FieldKey
  
  init(
  schema: String,
  alias: String? = nil,
  method: DatabaseQuery.ChildAggregateField.Method = .count,
  field: FieldKey,
  foreign: FieldKey,
  local: FieldKey
  )
  {
    self.schema = schema
    self.alias = alias
    self.method = method
    self.field = field
    self.foreign = foreign
    self.local = local
  }
}
