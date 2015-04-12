class AddColumnsToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :interviewer, :string
    add_column :interviews, :kind, :string
    add_column :interviews, :notes, :text
  end
end
