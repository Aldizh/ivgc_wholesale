class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.string :country
      t.integer :destination
      t.float :cost
      
      t.timestamps
    end
  end
end
