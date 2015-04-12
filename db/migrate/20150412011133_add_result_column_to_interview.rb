class AddResultColumnToInterview < ActiveRecord::Migration
  def change
    add_column :interviews, :result, :string
  end
end
