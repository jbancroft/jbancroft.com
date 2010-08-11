Factory.factories.each do |name, factory|
  Given /^an? #{name} exists with the following attributes:$/ do |attrs_table|
    attrs = {}
    attrs_table.raw.each do |(attr, value)|
      sanitized_attr = attr.gsub(/\s+/, "-").underscore
    attrs[sanitized_attr.to_sym] = value
    end
    Factory(name, attrs)
  end
end

Given /^a post with title "([^\"]*)" and body "([^\"]*)"$/ do |title, body|
  @post = Post.create!(:title => title, :body => body)
end

When /^I view the post$/ do
  visit post_path(@post)
end

When /^I visit the edit page for the post$/ do
  visit edit_post_path(@post)
end

Then /^I should see a form for correcting the errors in the post$/ do
  response.should have_selector('form') do |post_form|
    post_form.should have_selector('input', :type => 'text', :name => 'post[title]')
    post_form.should have_selector('textarea', :name => 'post[body]')
  end
end
