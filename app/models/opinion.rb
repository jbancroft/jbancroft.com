class Opinion < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :topic

  validates_presence_of :content, :topic, :author
end
