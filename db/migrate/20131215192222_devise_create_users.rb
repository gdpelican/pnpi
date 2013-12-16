class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      
      t.belongs_to :resource
      t.boolean :admin
      
      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end

    add_index :users, :reset_password_token, :unique => true
  end
end
