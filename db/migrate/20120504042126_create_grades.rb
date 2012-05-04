class CreateGrades < ActiveRecord::Migration
  def up
    create_table :grades do |t|
    end
  end

  def down
    drop_table :grades
  end
end
