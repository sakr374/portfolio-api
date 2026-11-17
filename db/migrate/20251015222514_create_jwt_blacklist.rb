class CreateJwtBlacklist < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_blacklist do |t|
      t.string :jti, null: false # JTI stands for JWT ID
      t.datetime :exp, null: false # Expiration time

      t.timestamps
    end

    add_index :jwt_blacklist, :jti, unique: true
  end
end