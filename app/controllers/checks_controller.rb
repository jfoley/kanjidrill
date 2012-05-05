class ChecksController < ApplicationController

  def create
    @check = Check.create(params[:check])
    render :json => @check.kanji.stats
  end
end
