class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :profile_pic, null: false
      t.string :id_front_side, null: false
      t.string :id_back_side, null: false
    end
  end
end
