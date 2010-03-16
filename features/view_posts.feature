Feature: View posts

	So that I can learn about programming
	As a blog reader
	I want to view posts on the blog

	Scenario: Show a list of all posts
		Given a post with title "Test Title" and body "Test Body"
		And a post with title "Test Title 2" and body "Test Body 2"
		When I go to the home page
		Then I should see "Test Title"
		And I should see "Test Body"
		And I should see "Test Title 2"
		And I should not see "Test Body 2"

	Scenario: Show a single post as html
		Given a post with title "Test Title" and body "Test Body"
		When I view the post
		Then I should see "Test Title"
		And I should see "Test Body"
