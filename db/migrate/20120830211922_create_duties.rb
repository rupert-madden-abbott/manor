class CreateDuties < ActiveRecord::Migration
  def change
    create_table :duties do |t|
      t.time :starts
      t.time :ends
      t.date :day

      t.timestamps
    end
  end
end
