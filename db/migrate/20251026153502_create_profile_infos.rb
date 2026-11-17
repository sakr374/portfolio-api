class CreateProfileInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :profile_infos do |t|
      t.text :about_me
      t.string :years_experience
      t.string :client_satisfaction
      t.string :projects_completed

      t.timestamps
    end
  end
end