class GEBuddy

    def call
        @portfolio = Portfolio.new
        
        input = 0
        until input == 6 do
            puts
            puts "1. View items in portfolio"
            puts "2. Get price history"
            puts "3. Add item to portfolio"
            puts "4. Add transaction"
            puts "5. View portfolio performance"
            puts "6. Exit"
            print "Select menu options: "
            input = gets.to_i
            puts

            case input
            when 1
                view_items_in_portfolio
            when 2
                get_price_history
            when 3
                add_item_to_portfolio
            when 4
                add_transaction
            when 5
                view_portfolio_performance
            end
        end
    end

    def view_items_in_portfolio
        item_keys = []
        i = 1

        @portfolio.items.each do |key, value|
            puts "#{i}. #{key}"  
            item_keys << key
            i += 1
        end

        puts "Your portfolio has no items." if item_keys.count == 0
        return item_keys
    end

    def get_price_history
        item_keys = view_items_in_portfolio

        if item_keys.count == 0
            return
        end
        
        input = 0
        until input > 0 && input <= item_keys.count
            puts "Select item from above choices, or enter 0 to exit:"
            input = gets.to_i
            return if input == 0
        end

        puts "Price history of #{item_keys[input - 1]}:"
        
        @portfolio.items[item_keys[input - 1]].daily_chart.each do |key, value|
            puts "#{key}: #{value}"
        end
    end

    def add_item_to_portfolio
        puts "Enter item ID number, or enter 0 to exit:"
        id = gets.to_i
        return if id <= 0
        item = @portfolio.add_item_by_id(id)
        puts "#{item.name} has been added to your portfolio."
    end

    def add_transaction
        item_keys = view_items_in_portfolio

        if item_keys.count == 0
            return
        end
        
        item_no = 0
        until item_no > 0 && item_no <= item_keys.count
            puts "Select item to buy/sell from above choices, or enter 0 to exit:"
            item_no = gets.to_i
            return if item_no == 0
        end

        selling = ""
        sell = nil
        until sell != nil
            puts "Selling? (y/n):"
            selling = gets.strip!
            sell = true if selling.eql? "y"
            sell = false if selling.eql? "n"
        end

        item_quantity = 0
        until item_quantity > 0
            puts "Enter a quantity to buy/sell:"
            item_quantity = gets.to_i
        end

        item_price = 0
        until item_price > 0
            puts "Enter total price to buy/sell:"
            item_price = gets.to_i
        end

        transaction = @portfolio.add_transaction(@portfolio.items[item_keys[item_no - 1]], item_quantity, item_price, sell)

        if transaction.sell
            print "Sold " 
        else
            print "Bought "
        end

        puts "#{transaction.quantity} #{transaction.item.name} for #{transaction.price} (~#{(transaction.price.to_f/transaction.quantity.to_f).floor} each)"
        puts
    end

    def view_portfolio_performance
        puts "Portfolio performance"
        puts "Total spending: #{@portfolio.spending}"
        puts "Total sales: #{@portfolio.revenue}"
        puts "Return: #{@portfolio.portfolio_return.round(2)}%"

        puts "Individual item performance:"
        puts
        @portfolio.items.each do |key, value|
            name = value.name
            puts "#{name}:"
            puts "Bought: #{@portfolio.item_quantity_bought(name)} for #{@portfolio.item_price_bought_total(name)} (~#{@portfolio.item_price_bought_average(name)} each)"
            puts "Sold: #{@portfolio.item_quantity_sold(name)} for #{@portfolio.item_price_sold_total(name)} (~#{@portfolio.item_price_sold_average(name)} each)"
            puts "Return: #{@portfolio.item_return(name).round(2)}%"
            puts
        end
    end
end


