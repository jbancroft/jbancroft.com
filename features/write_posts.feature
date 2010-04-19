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

	Scenario: Write new invalid post
		Given I have signed in with "author@example.com/authorpassword"
		When I go to the new post page
		And I fill in "Title" with "New Post Title"
		And I press "Save"
		Then I should see "There was a problem creating the post"
		And I should see a form for correcting the errors in the post
		And the "Title" field should contain "New Post Title"
		And the "Body" field should contain ""

	Scenario: Edit existing post
		Given I have signed in with "author@example.com/authorpassword"
		And a post with title "Test Title" and body "Test Body"
		When I visit the edit page for the post
		And I fill in "Title" with "Modified Test Title"
		And I fill in "Body" with "Modified Test Body"
		And I press "Save"
		Then I should see "Post updated successfully"
		And I should be on the posts page
		And I should see "Modified Test Title"

	Scenario: Edit existing post with invalid values
		Given I have signed in with "author@example.com/authorpassword"
		And a post with title "Test Title" and body "Test Body"
		When I visit the edit page for the post
		And I fill in "Title" with "Modified Test Title"
		And I fill in "Body" with ""
		And I press "Save"
		Then I should see "There was a problem updating the post. Please correct any errors and try again."
		And I should see a form for correcting the errors in the post
		And the "Title" field should contain "Modified Test Title"
