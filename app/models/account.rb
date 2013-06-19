require "rubygems"
require "sequel"
class Account < ActiveRecord::Base
  DB = Sequel.connect("mysql2://reports:u2ns8uj28yshu@208.65.111.153:3306/porta-billing")
  def self.authenticate(login, password)
    @users = DB[:users]
    @users.each do |user|
      if user[:login] == login
       if user[:password] == password
       return user
       else
       return nil
       end
      end
    end
    return nil
  end
end