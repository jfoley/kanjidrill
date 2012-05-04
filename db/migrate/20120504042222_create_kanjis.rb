class CreateKanjis < ActiveRecord::Migration
  def up
    create_table :kanjis do |t|
      t.string :glyph
      t.string :meaning

      t.references :grade
    end
  end

  def down
    drop_table :kanjis
  end
end
