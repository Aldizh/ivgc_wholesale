class AddRespondedToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :responded_to, :boolean, :default => false
  end
end
