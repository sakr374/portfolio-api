class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.text :message

      t.timestamps
    end
  end
end
