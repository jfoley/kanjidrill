class ChecksController < ApplicationController

  def create
    @check = Check.create(params[:check].merge(:user_id => current_user.id))
    render :json => @check.kanji.stats
  end
end
