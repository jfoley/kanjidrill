class ChecksController < ApplicationController

  def create
    check = current_user.checks.create!(params[:check])
    stats = KanjiStats.new(current_user, check.kanji)

    render :json => stats.stats
  end
end
