class RemoveTranscriptFromPings < ActiveRecord::Migration
  def change
    remove_column :pings, :transcript, :text
  end
end
