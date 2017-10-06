class CreateUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :selfie, :string, null: false
    add_column :users, :document_front_side, :string, null: false
    add_column :users, :document_back_side, :string, null: false
  end
end
