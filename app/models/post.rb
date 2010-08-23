class Post < ActiveRecord::Base
  validates_presence_of :title, :body
  belongs_to :author, :class_name => 'User'
end
