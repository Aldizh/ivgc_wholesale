class Rate < ActiveRecord::Base
  attr_accessible :country, :rate_cost

  def self.import(file)
  	 CSV.foreach(file.path, headers: true) do |row|
  	 	#to modify data
  	 	Rate.create! row.to_hash
  	 end
  end
end
