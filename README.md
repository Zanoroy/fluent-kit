<p align="center">
    <img 
        src="https://user-images.githubusercontent.com/1342803/58727365-19b1a280-83b2-11e9-8240-601f3e5fa68f.png" 
        height="64" 
        alt="FluentKit"
    >
    <br>
    Use the SPM string to easily include the dependendency in your `Package.swift` file.

```swift
    .package(url: "https://github.com/zanoroy/fluent-kit.git", from: 1.7.3.4)
```
    
<h2>APLHA</h2>
This is an Alpha release!!
<br>
Added child aggregate property wrapper to use:
<br>
Add the poperty to your model:

```swift
    public final class Department: Model,Content {

        public static let schema = "department"

        // 'Unique key for the record.'
        @ID(custom: "sysid", generatedBy: .database)
        public var id: Int?

        // Description for the department.
        @Field(key: "description")
        public var description: String

        // Freeform comment.
        @OptionalField(key: "comment")
        var comment: String?

        // Accountnumber.
        @OptionalField(key: "accountnumber")
        var accountnumber: String?

        ...

        @AggregateField(foreigntable: Account.schema, method: .count, field: "accountCount", local: "accountnumber", childfield: "accountnumber")
        var accountCount: Int?
        //  With the current version the "field" parameter must match the var name (in this case 'accountCount')

    }
    
```

<br>
<br>
With the current version the "field" parameter must match the var name (in this case 'accountCount') the querybuilder will not include the aggregate properties unless instructed to use them.
So the following with return the Department Model with accountCount being nil 

```swift    
return try Department.query(on: request.db).all()
```

<br>
<br>
The following call will include the sub-query and populate any AggregateField properties

```swift    
return try Department.query(on: request.db).withaggregatesubqueries()
```
<br>
<a href="https://docs.vapor.codes/4.0/">
    <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
</a>
<a href="https://discord.gg/vapor">
    <img src="https://img.shields.io/discord/431917998102675485.svg" alt="Team Chat">
</a>
<a href="LICENSE">
    <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
</a>
<a href="https://github.com/vapor/fluent-kit/actions">
    <img src="https://github.com/vapor/fluent-kit/workflows/test/badge.svg" alt="Continuous Integration">
</a>
<a href="https://swift.org">
    <img src="http://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 5.2">
</a>
</p>
