class ChecksController < ApplicationController

  def create
    @check = Check.create(params[:check].merge(:user_id => current_user.id))
    render :json => current_user.stats(@check.kanji)
  end
end
