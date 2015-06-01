class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.references :recruiter, index: true, foreign_key: true
      t.date :date
      t.string :company
      t.integer :culture
      t.integer :people
      t.integer :work
      t.integer :career
      t.integer :commute
      t.integer :salary
      t.integer :gut

      t.timestamps null: false
    end
  end
end
