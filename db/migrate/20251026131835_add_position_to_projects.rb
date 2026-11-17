# db/migrate/YYYYMMDDHHMMSS_add_position_to_projects.rb
class AddPositionToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :position, :integer, default: 0
    
    # Optional: Add an index for faster sorting
    add_index :projects, :position
  end
end