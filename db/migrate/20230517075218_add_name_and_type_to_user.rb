# frozen_string_literal: true

# AddNameAndTypeToUser
class AddNameAndTypeToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name
      t.integer :role_type, default: 0
    end
  end
end
