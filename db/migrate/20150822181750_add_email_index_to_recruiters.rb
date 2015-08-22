class AddEmailIndexToRecruiters < ActiveRecord::Migration
  def change
    add_index :recruiters, :email
  end
end
