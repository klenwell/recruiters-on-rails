class AddScoreToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :score, :integer
    add_index :recruiters, :score
  end
end
