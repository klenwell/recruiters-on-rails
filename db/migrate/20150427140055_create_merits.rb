class CreateMerits < ActiveRecord::Migration
  def change
    create_table :merits do |t|
      t.references :recruiter, index: true, foreign_key: true
      t.string :reason
      t.integer :value
      t.date :date

      t.timestamps null: false
    end
  end
end
