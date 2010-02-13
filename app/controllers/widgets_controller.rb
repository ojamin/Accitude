class WidgetsController < ApplicationController

  def items_more
    ren_cont 'items_more' and return
  end

  def item_new_process
    return unless params[:item] && (@item = Item.new(params[:item]))
    @item.save
    @item_ids = JSON.generate([[JSON.parse(params[:item_ids2])] + [@item.id]].flatten)
    @colour_id = (params[:colour_id] || '2')
  end

end
