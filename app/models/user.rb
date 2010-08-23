class User < ActiveRecord::Base
  include Clearance::User

  def name
    "#{self[:first_name]} #{self[:last_name]}"
  end
end
