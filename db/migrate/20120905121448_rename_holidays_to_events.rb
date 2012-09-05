class RenameHolidaysToEvents < ActiveRecord::Migration
  def change
    rename_table :holidays, :events
  end
end
