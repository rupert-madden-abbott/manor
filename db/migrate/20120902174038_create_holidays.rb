class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :name
      t.date :day
      t.time :duty_starts
      t.time :duty_ends

      t.timestamps
    end
  end
end
