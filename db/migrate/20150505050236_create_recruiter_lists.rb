class CreateRecruiterLists < ActiveRecord::Migration
  def change
    create_table :recruiter_lists do |t|
      t.string :name
      t.timestamps null: false
    end

    add_reference :recruiters, :recruiter_list, index: true
  end
end
