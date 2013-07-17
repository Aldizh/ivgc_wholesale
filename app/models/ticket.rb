class Ticket < ActiveRecord::Base
  has_many :responses 
  attr_accessible :title, :body, :owner, :responded_to

  validates :title, :body, :owner, presence: true

end
