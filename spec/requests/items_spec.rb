require 'rails_helper'

RSpec.describe "Item", type: :request do
   
    before(:each) do 
        #create database record for wedding band
        Item.create(description: '24k Gold Wedding Band', price: 1277.99, stockQty: 5 ) 
    end
    
    describe "GET /items/:id" do
        it 'get item information for item 1' do
          headers = { "ACCEPT" => "application/json"}    # Rails 4 
          get '/items/1', headers: headers
          expect(response).to have_http_status(200)
          json_response = JSON.parse(response.body) 
          item = json_response
          expect(item.keys).to include( 
            'id',
            'description',
            'price',
            'stockQty')
          expect(item['description']).to eq '24k Gold Wedding Band'
          expect(item['price']).to eq '1277.99'
          expect(item['stockQty']).to eq 5
        end 
        
        it 'get item information for non existent item should return 404' do 
          headers = { "ACCEPT" => "application/json"}    # Rails 4 
          get '/items/0', headers: headers
          expect(response).to have_http_status(404)
          #json_response = JSON.parse(response.body) 
          #expect(json_response.length).to eq 0
        end 
    end
    
    describe "POST /items" do
        it 'post of new item should return item information' do
          headers = { "CONTENT_TYPE" => "application/json" ,
                       "ACCEPT" => "application/json"}    # Rails 4
          item_new = {description: '14k Gold Wedding Band', price: 277.99, stockQty: 3} 
          post '/items',  params: item_new.to_json, headers: headers
          expect(response).to have_http_status(201)
          item = JSON.parse(response.body) 
           expect(item.keys).to include( 
             'id',
            'description',
            'price',
            'stockQty')
          expect(item['description']).to eq '14k Gold Wedding Band'
          expect(item['price']).to eq '277.99'
          expect(item['stockQty']).to eq 3
          
          # check that database has been updated
          itemdb = Item.find(item['id'])
          expect(itemdb.description).to eq '14k Gold Wedding Band'
          expect(itemdb.price).to eq 277.99
          expect(itemdb.stockQty).to eq 3
        end 
        
        it 'post of new item missing price information should return 400 and error msg' do
          headers = { "CONTENT_TYPE" => "application/json" ,
                       "ACCEPT" => "application/json"}    # Rails 4
          item_new = {description: '14k Gold Wedding Band', stockQty: 3} 
          post '/items',  params: item_new.to_json, headers: headers
          expect(response).to have_http_status(400)
          item = JSON.parse(response.body) 
          expect(item.keys).to include('price')
          expect(item['price']).to eq ["can't be blank", "is not a number"]
        end 
        
         it 'post of new item missing stock information should return 400 and error msg' do
          headers = { "CONTENT_TYPE" => "application/json" ,
                       "ACCEPT" => "application/json"}    # Rails 4
          item_new = {description: '14k Gold Wedding Band', price: 3.99} 
          post '/items',  params: item_new.to_json, headers: headers
          expect(response).to have_http_status(400)
          item = JSON.parse(response.body) 
          expect(item.keys).to include('stockQty')
          expect(item['stockQty']).to eq ["can't be blank", "is not a number"]
        end 
        
        it 'post of new item missing description information should return 400 and error msg' do
          headers = { "CONTENT_TYPE" => "application/json" ,
                       "ACCEPT" => "application/json"}    # Rails 4
          item_new = {price: 3.99, stockQty: 5} 
          post '/items',  params: item_new.to_json, headers: headers
          expect(response).to have_http_status(400)
          item = JSON.parse(response.body) 
          expect(item.keys).to include('description')
          expect(item['description']).to eq ["can't be blank"]
        end 
        
        it 'post of new item should with non numeric stockQty should return 400 and error' do
          headers = { "CONTENT_TYPE" => "application/json" ,
                       "ACCEPT" => "application/json"}    # Rails 4
          item_new = {description: '14k Gold Wedding Band', price: 5.99, stockQty: 'a'} 
          post '/items',  params: item_new.to_json, headers: headers
          expect(response).to have_http_status(400)
          item = JSON.parse(response.body)
          expect(item['stockQty']).to eq ["is not a number"]
        end
        
        it 'post of new item should with non numeric price should return 400 and error' do
          headers = { "CONTENT_TYPE" => "application/json" ,
                       "ACCEPT" => "application/json"}    # Rails 4
          item_new = {description: '14k Gold Wedding Band', price: 'a', stockQty: 3} 
          post '/items',  params: item_new.to_json, headers: headers
          expect(response).to have_http_status(400)
          item = JSON.parse(response.body)
          expect(item['price']).to eq ["is not a number"]
        end
        
      end
    
    describe "PUT /items/" do
      it 'update of a item should return updated item information' do
        headers = { "CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    # Rails 4
        item_new = {description: '15k Gold Wedding Band', price: 999.99, stockQty: 5}
        post '/items',  params: item_new.to_json, headers: headers
        expect(response).to have_http_status(201)
        item = JSON.parse(response.body)   
        # update the item price and issue http put
        item['price']= 799.99
        put '/items', params: item.to_json, headers: headers 
        expect(response).to have_http_status(200)
        item_returned = JSON.parse(response.body)
        expect(item_returned['price']).to eq item['price'].to_s
        
        # verify db change
        itemdb = Item.find(item['id'])
        expect(itemdb.price).to eq item['price']
      end 
      
      it 'update of non existant item should return 404' do
        headers = { "CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"}    # Rails 4
        item_update = {id: 3, description: '24k Platinum Band', price: 1999.99, stockQty: 1}
        put '/items', params: item_update.to_json, headers: headers
        expect(response).to have_http_status(404)
      end
    end
    
    describe "PUT /items/order" do
      it 'Place item order for item 1' do
        headers = { "CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"} 
        item = Hash.new
        item[:id] = 1
        put  '/items/order', params: item.to_json, headers: headers
        expect(response).to have_http_status(204)
        itemdb = Item.find(1)
        expect(itemdb.stockQty).to eq 4
          
      end
      
      it 'Place item order for non existent item returns 404' do
        headers = { "CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"} 
        item = Hash.new
        item[:id] = 3
        put  '/items/order', params: item.to_json, headers: headers
        expect(response).to have_http_status(404)
        begin
          itemdb = Item.find(3)
        rescue ActiveRecord::RecordNotFound => e
           itemdb = nil
        end
        expect(itemdb).to eq nil
      end
      
      it 'Place item order for item that has no stock returns 400' do
        Item.create(description: '11k Gold Wedding Band', price: 1277.99, stockQty: 0 )
        headers = { "CONTENT_TYPE" => "application/json" ,
                     "ACCEPT" => "application/json"} 
        item = Hash.new
        item[:id] = 2
        put  '/items/order', params: item.to_json, headers: headers
        expect(response).to have_http_status(400)
      end
    end
end