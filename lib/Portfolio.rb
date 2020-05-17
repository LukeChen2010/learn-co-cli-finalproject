class Portfolio

    attr_reader :items, :transactions, :spending, :revenue

    def initialize
        @items = {}
        @transactions = []
        @spending = 0
        @revenue = 0
    end
    
    def add_item(item)
        @items[item.name] = item
    end

    def add_item_by_id(id)
        item = RuneScapeItem.new(id)
        @items[item.name] = item
        return item
    end

    def delete_item(name)
        @items.delete(name)
    end

    def add_transaction(item, quantity, price, sell)
        @items[item.name] = item

        transaction = Transaction.new(item, quantity, price, sell)
        @transactions << transaction

        if sell 
            @revenue += price 
        else
            @spending += price
        end

        return transaction
    end

    def item_performance(name)
        quantity_bought = 0
        quantity_sold = 0 
        price_bought = 0
        price_sold = 0

        item_buys = @transactions.find_all {|x| x.item.name == name && x.sell == false}
        item_sales = @transactions.find_all {|x| x.item.name == name && x.sell == true}

        item_buys.each do |x|
            quantity_bought += x.quantity
            price_bought += x.price
        end

        item_sales.each do |x|
            quantity_sold += x.quantity
            price_sold += x.price
        end

        puts "#{items[name].name}:"
        puts "Bought: #{quantity_bought} for #{price_bought} (~#{(price_bought.to_f/quantity_bought.to_f).floor} each)"
        puts "Sold: #{quantity_sold} for #{price_sold} (~#{(price_sold.to_f/quantity_sold.to_f).floor} each)"
        puts "Return: #{(100*(price_sold.to_f-price_bought.to_f)/price_bought.to_f).round(2)}%"
    end

    def portfolio_performance
        puts "Portfolio Performance"
        puts "Total spending: #{spending}"
        puts "Total sales: #{revenue}"
        puts "Return: #{(100*(revenue.to_f-spending.to_f)/spending.to_f).round(2)}%"

        return if @transactions.count == 0
        
        puts
        puts "Performance by Item:"

        @items.each do |key, value|
            puts
            self.item_performance(value.name)
        end
    end

end