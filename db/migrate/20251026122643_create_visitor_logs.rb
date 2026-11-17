class CreateVisitorLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :visitor_logs do |t|
      t.string :visitor_key
      t.date :visited_at

      t.timestamps
    end

    # Add this index to ensure a visitor_key can only be logged once per day
    add_index :visitor_logs, [:visitor_key, :visited_at], unique: true
  end
end