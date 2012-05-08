class ChecksController < ApplicationController

  def create
    check = Check.create(params[:check].merge(:user_id => current_user.id))
    stats = KanjiStats.new(current_user, check.kanji)

    render :json => stats
  end
end
