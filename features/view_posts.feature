Feature: View posts

	So that I can learn about programming
	As a blog reader
	I want to view posts on the blog

	Scenario: Show a list of all posts
		Given a post exists with the following attributes:
    | Title | "Test Title" |
    | Body  | "Test Body"  |
		And a post exists with the following attributes:
    | Title | "Test Title 2" |
    | Body  | "Test Body 2"  |
		When I go to the home page
		Then I should see "Test Title"
		And I should see "Test Body"
		And I should see "Test Title 2"
		And I should not see "Test Body 2"

	Scenario: Show a single post as html
		Given a post exists with the following attributes:
    | Title | "Test Title" |
    | Body  | "Test Body"  |
		When I go to the home page
    And I follow "Test Title"
		Then I should see "Test Title"
		And I should see "Test Body"
