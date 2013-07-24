class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.string :country
      t.float :rate_cost

      t.timestamps
    end
  end
end
