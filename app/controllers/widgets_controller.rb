class WidgetsController < ApplicationController

  def items_more
    ren_cont 'items_more' and return
  end

  def test
    logger.info "test method called"
    return unless params[:id] && (@item = Item.find_by_id params[:id])
    logger.info "return line passed"
  end

  def item_new_process
    return unless params[:item] && (@item = Item.new(params[:item]))
    @item.save
    @item_ids = JSON.generate([[JSON.parse(params[:item_ids2])] + [@item.id]].flatten)
    @colour_id = (params[:colour_id] || '2')
  end

  def item_edit_process
    logger.info "edit method called"
    if params[:commit]
      return unless params[:item] && (@item = Item.find_by_id(params[:id]))
      logger.info "passed validation"
      @item.update_attributes params[:item]
      @item_ids = params[:item_ids2] #JSON.generate([[JSON.parse(params[:item_ids2])] + [@item.id]].flatten)
      @colour_id = (params[:colour_id] || '2')
    end
  end

  def item_delete
    @item = Item.find_by_id params[:id]
    @item.delete
    flash[:notice] = "Item #{@item.desc} deleted"
  end

end
