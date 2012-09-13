class AddPublishedToRota < ActiveRecord::Migration
  def change
    add_column :rota, :published, :boolean, default: false
  end
end
