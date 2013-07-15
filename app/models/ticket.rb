class Ticket < ActiveRecord::Base
  attr_accessible :title, :body, :owner

  validates :title, :body, :owner, presence: true

end
