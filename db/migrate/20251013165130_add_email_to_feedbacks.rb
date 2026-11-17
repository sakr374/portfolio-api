class AddEmailToFeedbacks < ActiveRecord::Migration[8.0]
  def change
    add_column :feedbacks, :email, :string
  end
end
