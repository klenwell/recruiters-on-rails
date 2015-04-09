class RemoveValueFieldFromPings < ActiveRecord::Migration
  def change
    remove_column :pings, :value, :integer
  end
end
