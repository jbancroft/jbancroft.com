Feature: Write posts

	So that I can share my thoughts on the internet
	As an author
	I want to be able to write blog posts

	Scenario: Write new post
		Given I have signed in with "author@example.com/authorpassword"
		When I go to the new post page
		And I fill in "Title" with "New Post Title"
		And I fill in "Body" with "New Post Body"
		And I press "Save"
		Then I should see "Post created successfully"
		And I should be on the posts page
		And I should see "New Post Title"
