require "open-uri"
require "net/http"
require "json"
require "date"

class RuneScapeItem

    attr_accessor :id
    attr_accessor :item, :icon, :icon_large, :type, :typeIcon, :name, :description, :members, :current, :today, :day30, :day90, :day180
    attr_accessor :daily_chart, :average_chart

    def initialize(id)
        @id = id
        @daily_chart = {}
        @average_chart = {}
        self.get_item_details
        self.get_price_chart
    end

    def get_item_details
        url = "http://services.runescape.com/m=itemdb_rs/api/catalogue/detail.json?item=#{@id}"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        payload = JSON.parse(response.body)

        @item = payload["item"]
        @icon = @item["icon"]
        @icon_large = @item["icon_large"]
        @type = @item["type"]
        @typeIcon = @item["typeIcon"]
        @name = @item["name"]
        @description = @item["description"]
        @members = @item["members"]
        @current = @item["current"]
        @today = @item["today"]
        @day30 = @item["day30"]
        @day90 = @item["day90"]
        @day180 = @item["day180"]
    end

    def get_price_chart
        url = "http://services.runescape.com/m=itemdb_rs/api/graph/#{@id}.json"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        payload = JSON.parse(response.body)

        daily_hash = payload["daily"]
        average_hash = payload["average"]

        date = nil
        
        daily_hash.each do |key, value|
             date = Time.at(key.to_i/1000)
             @daily_chart[date.strftime("%m/%d/%Y")] = value
        end

        average_hash.each do |key, value|
            date = Time.at(key.to_i/1000)
            @average_chart[date.strftime("%m/%d/%Y")] = value
       end
    end

    def print_daily_chart
        daily_chart.each do |key, value|
            puts "#{key}: #{value}"
        end
    end

    def print_average_chart
        average_chart.each do |key, value|
            puts "#{key}: #{value}"
        end
    end

end

class Transaction

    attr_accessor :item, :quantity, :price, :sell, :value

    def initialize(item, quantity, price, sell)
        @item = item
        @quantity = quantity
        @price = price
        @sell = sell
    end

end

class Portfolio

    attr_accessor :items, :transactions 

    def initialize
        @items = {}
        @transactions = []
    end

    def add_item(id)
        item = RuneScapeItem.new(id)
        @items[item.name] = item
    end

    def delete_item(name)
        @items.delete(name)
    end

    def add_transaction(item, quantity, price, sell)
        transaction = Transaction.new(item, quantity, price, sell)
        @transactions << transaction
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
    end

end