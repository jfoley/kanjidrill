class RenameResults < ActiveRecord::Migration
  def up
    Check.where(:result => :no).update_all(:result => :hard)
    Check.where(:result => :maybe).update_all(:result => :normal)
    Check.where(:result => :yes).update_all(:result => :easy)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
