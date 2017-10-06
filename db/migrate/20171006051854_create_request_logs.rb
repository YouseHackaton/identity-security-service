class CreateRequestLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :request_logs do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.integer :request_type, null: false, index: true
      t.jsonb :request_content

      t.timestamps
    end
  end
end
