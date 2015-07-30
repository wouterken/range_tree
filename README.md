# RangeTree

Range Tree provides a flexible and efficient data structure for easily querying variables indexed by ranges.

With a range tree you can easily query state at a given point
or timestamp and or all variables that overlap with a given range.

You can also use it to iterate through all points or all unique configurations contained within the range tree.

You can use integers, floats, dates, times or similar comparable
objects as range keys.

For small trees you can use the default settings
which rebuild the tree every time you add a value.

If you need to build a very large tree with 1000's of values
you need to pass ```rebuild_on_add: false``` to the tree.
Then add everything to your tree and only once it is complete
you must call ```tree.rebuild``` to build your index.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'range_tree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install range_tree

## Usage


```ruby
# Below is an example using integers (formatted as dates) as keys. You can just as easily use dates, times
# floats or other comparable types.

require 'range_tree'

staff_holidays = RangeTree::Tree.new

staff_holidays[2000_01_01, 2000_01_15] = "John"
staff_holidays[2000_01_15, 2000_01_31] = "Greig"
staff_holidays[2000_01_20, 2000_02_05] = "Eve"
staff_holidays[2000_01_03, 2000_01_08] = "Alice"
staff_holidays[2000_01_18, 2000_01_20] = "Bob"

# Check who is on holiday on certain dates
staff_holidays[2000_01_04]
=> ["Alice", "John"]

# Check all staff members on holiday within a certain period by passing a range
staff_holidays[2000_01_12..2011_01_19]
=> ["John", "Bob", "Greig", "Eve"]


# Iterate through all periods where the system state changes
staff_holidays.distinct.each do |date, staff|
  puts "From #{date} #{staff} will be on holiday"
end

=>
From 20000101 ["John"] will be on holiday
From 20000103 ["John", "Alice"] will be on holiday
From 20000109 ["John"] will be on holiday
From 20000115 ["John", "Greig"] will be on holiday
From 20000116 ["Greig"] will be on holiday
From 20000118 ["Greig", "Bob"] will be on holiday
From 20000120 ["Greig", "Bob", "Eve"] will be on holiday
From 20000121 ["Greig", "Eve"] will be on holiday
From 20000132 ["Eve"] will be on holiday
From 20000206 [] will be on holiday

# Iterate though all periods in the tree.
staff_holidays.all.each do |date, staff|
  puts "#{staff} is on holiday on #{date}"
end

=>
["John"] is on holiday on 20000101
["John"] is on holiday on 20000102
["John", "Alice"] is on holiday on 20000103
["John", "Alice"] is on holiday on 20000104
["John", "Alice"] is on holiday on 20000105
["John", "Alice"] is on holiday on 20000106
["John", "Alice"] is on holiday on 20000107
["John", "Alice"] is on holiday on 20000108
["John"] is on holiday on 20000109
["John"] is on holiday on 20000110
["John"] is on holiday on 20000111
...
```
