class AddJourneyFieldToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :journey, :jsonb
  end
end
