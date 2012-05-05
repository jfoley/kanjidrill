class CreateChecks < ActiveRecord::Migration
  def up
    create_table :checks do |t|
      t.string :result
      t.references :kanji
      t.references :user

      t.timestamps
    end
  end

  def down
    drop_table :checks
  end
end
