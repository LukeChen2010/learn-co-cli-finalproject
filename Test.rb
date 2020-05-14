require_relative "RuneScapeItem.rb"
require_relative "Portfolio.rb"
require_relative "Transaction.rb"

glaiven_boots = RuneScapeItem.new(21790)

myport = Portfolio.new
steadfast_boots= myport.add_item_by_id(21787)
myport.add_item(glaiven_boots)

myport.add_transaction(steadfast_boots, 3, 4000000, false)
myport.add_transaction(steadfast_boots, 7, 5000000, false)
myport.add_transaction(steadfast_boots, 4, 7000000, false)
myport.add_transaction(steadfast_boots, 9, 9000000, true)
myport.add_transaction(steadfast_boots, 5, 7200000, true)

myport.add_transaction(glaiven_boots, 9, 9000000, false)
myport.add_transaction(glaiven_boots, 9, 9100000, true)

myport.item_performance("Steadfast boots")
puts
myport.item_performance("Glaiven boots")
