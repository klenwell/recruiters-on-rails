class CreateRecruiters < ActiveRecord::Migration
  def change
    create_table :recruiters do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :company
      t.string :phone

      t.timestamps null: false
    end
  end
end
