class ItemsController < ApplicationController
   before_action :set_item, only: [:update, :index]
   
  # GET /items/:id
  def index
      respond_to do |format|
        if @item.nil?
            format.json {head :not_found}
        else
            format.json { render json: @item, status: :ok, location: @items}
        end
    end
  end
   # POST /items
   def create
     @item = Item.new(item_params)
     respond_to do |format|
       if @item.save
         format.json { render json: @item, status: :created, location: @items }
       else
         format.json { render json: @item.errors, status: :bad_request }
       end
     end
   end

  # PUT /items
  def update
    respond_to do |format|
      if @item.nil?
          format.json { head :not_found }
      elsif @item.update(item_params)
        format.json { head :no_content }
      else
        format.json { render json: @item.errors, status: :bad_request }
      end
    end
  end
  
  # PUT /items/order
  def order
     begin
        @item = Item.find(params[:itemId])
     rescue ActiveRecord::RecordNotFound => e
        @item = nil
     end 
     respond_to do |format|
         if @item.nil?
             format.json { head :not_found}
         elsif @item[:stockQty] > 0
             itemP = Hash.new
             itemP[:id] = @item[:id]
             itemP[:description] = @item[:description]
             itemP[:price] = @item[:price].to_s
             itemP[:stockQty] = @item[:stockQty] - 1
             if @item.update(itemP)
                 format.json { render json: {}, status: :no_content, location: @items}
             else
                 #format.json { render json: {}, status: :bad_request}
                 head status: :bad_request
             end
         else
             format.json { render json: {}, status: :bad_request}
         end
     end     
  end
    
    
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
        begin
           @item = Item.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
           @item = nil
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:id, :description, :price, :stockQty, :itemId)
    end
end