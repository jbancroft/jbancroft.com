Feature: citizens have a debate

	A person expresses an opinion on a topic that they care about.  If the topic does not exist yet, it gets created and shows up at the top of the newest topics page.  Also, it is added to that person's stream of opinions.  Another person may respond to this opinion by offering a counter-argument, which sets up a debate.  Any number of users may post messages in response to something that somebody said in the debate, but once a user has posted an opinion for or against a particular side, they may not change sides unless they agree to let the system delete all of their previous posts in the debate.

  @wip
	Scenario: person expresses an opinion on a new topic
		Given I have signed in with "person1@example.com/person1pass"
		And I am on the home page
		When I follow "Post an Opinion"
		And I fill in "Topic" with "Climate Change"
		And I fill in "Opinion" with "I think burning fossil fuels causes climate change."
		And I press "Express Yourself!"
		Then I should see "Thank you for contributing your opinion"
		And the newest topic should be "Climate Change"
		And my newest opinion should be "I think burning fossil fuels causes climate change." on the topic of "Climate Change"

  @wip
	Scenario: person expresses an opinion on an existing topic
		Given a topic named "Climate Change"
		And a topic named "Social Security"
		And I have signed in with "person1@example.com/person1pass"
		When I go to the new opinion page
		And I fill in "Topic" with "Climate Change"
		And I fill in "Opinion" with "I think burning fossil fuels causes climate change."
		And I press "Express Yourself!"
		Then I should see "Thank you for contributing your opinion"
		And my newest opinion should be "I think burning fossil fuels causes climate change." on the topic of "Climate Change"
		And the newest topic should be "Social Security"

  @wip
	Scenario: person responds to an opinion
		Given I am signed up and confirmed as "person1@example.com/person1pass"
		And a topic named "Climate Change"
		And an opinion "I think burning fossil fuels causes climate change." belonging to "person1@example.com"
		And I have signed in with "person2@example.com/person2pass"
		When I view the opinion "I think burning fossil fuels causes climate change." belonging to "person1@example.com"
		And I follow "Respond"
		And I fill in "Response" with "No it doesn't."
		And I press "Respond"
		Then I should see "I think burning fossil fuels causes climate change."
		And I should see "No it doesn't."
		And I should be on the debate page for "Climate Change" between "person1@example.com" and "person2@example.com"
