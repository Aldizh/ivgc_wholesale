class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.belongs_to :ticket
      t.string :description
      t.integer :ticket_id
      t.timestamps
    end
  end
end
