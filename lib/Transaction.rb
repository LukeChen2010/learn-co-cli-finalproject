class Transaction

    attr_reader :item, :quantity, :price, :sell, :value

    def initialize(item, quantity, price, sell)
        @item = item
        @quantity = quantity
        @price = price
        @sell = sell
    end

end