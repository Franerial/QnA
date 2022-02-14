class SearchesController < ApplicationController
  def show
    return if params[:query].blank? || params[:resources].blank?

    @records = Search.new(params[:query], params[:resources]).call
  end
end
