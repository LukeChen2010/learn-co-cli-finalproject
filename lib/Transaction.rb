class Transaction 

    attr_reader :item, :quantity, :price, :sell, :portfolio
    @@all = []

    def initialize(item, quantity, price, sell, portfolio)
        @item = item
        @quantity = quantity
        @price = price
        @sell = sell
        @portfolio = portfolio
        @@all << self
    end

    def self.all
        @@all
    end

end