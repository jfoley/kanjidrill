class GradesController < ApplicationController
  def index

  end

  def show
    @kanji = Kanji.where(grade_id: params[:id])
  end
end
