require 'httparty'

class MakeHttpRequests
    
    include HTTParty

    # default_options.update(verify: false) # Turn off SSL
    base_uri  "http://localhost:8080" 
    headers = { 'Content-Type' => 'application/json',
                'ACCEPT' => 'application/json'}
                

    input = ""

    while input != 'quit'
        
        puts 'What do you want to do: create, update, get or quit'
        input = gets.chomp!
        
        case input
          when 'create'
              item_new = Hash.new
              puts 'Please enter item description'
              item_new[:description] = gets.chomp!
              puts 'Please enter item price'
              item_new[:price] = gets.chomp!
              puts 'Please enter item stock quantity'
              item_new[:stockQty] = gets.chomp!
            
              response = post '/items',
                body: item_new.to_json,
                headers: headers
                
              puts "status code #{response.code}"
              item = JSON.parse(response.body)
              puts item
          when 'update'
              item_update = Hash.new
              puts 'Please enter id of item to update'
              item_update[:id] = gets.chomp!
              puts 'Please enter item description'
              item_update[:description] = gets.chomp!
              puts 'Please enter item price'
              item_update[:price] = gets.chomp!
              puts 'Please enter item stock quantity'
              item_update[:stockQty] = gets.chomp!
              
              response = put '/items',
                body: item_update.to_json,
                headers: headers
                
              puts "status code #{response.code}"
              if response.code == 400
                item = JSON.parse(response.body)
                puts item
              end
          when 'get'
              puts 'Please enter id of item to lookup'
              item_get = gets.chomp!
              
              response = get "/items/#{item_get}",
                headers: headers
                
              puts "status code #{response.code}"
              if response.code == 200
                item = JSON.parse(response.body)
                puts item
              end
              
          when 'order'
              #check if itemID or id will be used
              item_order = Hash.new
              puts 'Please enter the item id of the item to order'
              item_order[:id] = gets.chomp!
              
              response = put '/items/order',
                body: item_order.to_json,
                headers: headers
                
              puts "status code #{response.code}"
              #No content returned
        end
      puts ""
    end

end