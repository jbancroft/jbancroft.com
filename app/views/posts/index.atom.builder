atom_feed do |feed|
  feed.title 'Developing Thoughts'
  feed.updated @posts.first.created_at
  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title post.title
      entry.content markdown(post.body), :type => 'html'
      entry.author do |author|
        author.name post.author.name
      end
    end
  end
end
