class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.references :recruiter, index: true, foreign_key: true
      t.string :color
      t.boolean :active
      t.string :reason

      t.timestamps null: false
    end
  end
end
