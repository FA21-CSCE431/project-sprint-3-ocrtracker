# frozen_string_literal: true

# DeviseCreateUsers
class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :full_name
      t.string :uid
      t.string :avatar_url
      t.boolean :is_admin
      t.string :description

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
