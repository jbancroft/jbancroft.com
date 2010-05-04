class AddAuthorToOpinion < ActiveRecord::Migration
  def self.up
    add_column :opinions, :author_id, :integer
  end

  def self.down
    remove_column :opinions, :author_id
  end
end
