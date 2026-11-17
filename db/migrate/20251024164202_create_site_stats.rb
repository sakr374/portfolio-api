class CreateSiteStats < ActiveRecord::Migration[8.0]
  def change
    create_table :site_stats do |t|
      # Add default: 0
      t.integer :visitor_count, default: 0

      t.timestamps
    end

    # Add this line to create the first record
    SiteStat.create(visitor_count: 0)
  end
end