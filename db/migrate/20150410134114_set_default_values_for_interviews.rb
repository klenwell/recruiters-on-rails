class SetDefaultValuesForInterviews < ActiveRecord::Migration
  def up
    change_column :interviews, :culture, :integer, default: 1
    change_column :interviews, :people, :integer, default: 1
    change_column :interviews, :work, :integer, default: 1
    change_column :interviews, :career, :integer, default: 1
    change_column :interviews, :commute, :integer, default: 1
    change_column :interviews, :salary, :integer, default: 1
    change_column :interviews, :gut, :integer, default: 1
  end

  def down
    # No changes needed.
  end
end
