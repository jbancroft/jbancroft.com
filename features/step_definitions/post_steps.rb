Given /^a post with title "([^\"]*)" and body "([^\"]*)"$/ do |title, body|
  @post = Post.create!(:title => title, :body => body)
end

When /^I view the post$/ do
  visit post_path(@post)
end

When /^I visit the edit page for the post$/ do
    visit edit_post_path(@post)
end
