class CreateUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :selfie, :string
    add_column :users, :document_front_side, :string
    add_column :users, :document_back_side, :string
  end
end
