class AddPreferencesCountToDuties < ActiveRecord::Migration
  def change
    add_column :duties, :preferences_count, :integer
  end
end
