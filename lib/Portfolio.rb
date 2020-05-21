class Portfolio

    attr_reader :items, :transactions, :spending, :revenue

    def initialize
        @items = {}
        @transactions = Transaction.all
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

        transaction = Transaction.new(item, quantity, price, sell, self)

        if sell 
            @revenue += price 
        else
            @spending += price
        end

        return transaction
    end

    def portfolio_transactions
        return @transactions.find_all {|x| x.portfolio == self}
    end

    def portfolio_sell_transactions
        return portfolio_transactions.find_all {|x| x.sell == true}
    end

    def portfolio_buy_transactions
        return portfolio_transactions.find_all {|x| x.sell == false}
    end

    def item_quantity_bought(name)
        quantity_bought = 0

        item_buys = portfolio_buy_transactions.find_all {|x| x.item.name == name}

        item_buys.each do |x|
            quantity_bought += x.quantity
        end

        return quantity_bought
    end

    def item_price_bought_total(name)
        price_bought = 0

        item_buys = portfolio_buy_transactions.find_all {|x| x.item.name == name}

        item_buys.each do |x|
            price_bought += x.price
        end

        return price_bought
    end

    def item_price_bought_average(name)
        return 0 if item_quantity_bought(name) == 0
        return (item_price_bought_total(name).to_f/item_quantity_bought(name).to_f).floor
    end

    def item_quantity_sold(name)
        quantity_sold = 0 

        item_sales = portfolio_sell_transactions.find_all {|x| x.item.name == name}

        item_sales.each do |x|
            quantity_sold += x.quantity
        end

        return quantity_sold
    end

    def item_price_sold_total(name)
        price_sold = 0 

        item_sales = portfolio_sell_transactions.find_all {|x| x.item.name == name}

        item_sales.each do |x|
            price_sold += x.price
        end

        return price_sold
    end

    def item_price_sold_average(name)
        return 0 if item_quantity_sold(name) == 0
        return (item_price_sold_total(name).to_f/item_quantity_sold(name).to_f).floor
    end

    def item_return(name)
        return 0 if item_quantity_bought(name) == 0
        return 100*(item_price_sold_total(name) - item_price_bought_total(name)).to_f/item_price_bought_total(name).to_f
    end

    def portfolio_return
        return nil if @transactions.count == 0
        return 100*(revenue - spending).to_f/spending.to_f
    end

end