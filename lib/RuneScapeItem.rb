class RuneScapeItem

    attr_reader :id
    attr_reader :item, :icon, :icon_large, :type, :typeIcon, :name, :description, :members, :current, :today, :day30, :day90, :day180
    attr_reader :daily_chart, :average_chart

    def initialize(id)
        @id = id
        @daily_chart = {}
        @average_chart = {}
        self.get_item_details
        self.get_price_chart
    end

    def get_item_details
        url = "http://services.runescape.com/m=itemdb_rs/api/catalogue/detail.json?item=#{@id}"
        payload = API_Bootstrap.get_payload(url)

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
        payload = API_Bootstrap.get_payload(url)

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
