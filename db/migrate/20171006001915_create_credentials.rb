class CreateCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :credentials do |t|
      t.string :provider
      t.string :token
      t.datetime :expires_at
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
