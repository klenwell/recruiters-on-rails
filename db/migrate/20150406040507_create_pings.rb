class CreatePings < ActiveRecord::Migration
  def change
    create_table :pings do |t|
      t.references, :recruiter
      t.string, :kind
      t.string, :note
      t.text, :transcript
      t.integer, :value
      t.date :date

      t.timestamps null: false
    end
  end
end
