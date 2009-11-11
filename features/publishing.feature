Feature: Publishing posts
  In order to publish my ideas
  As an author
  I want publish posts
  
  Scenario: Cannot publish post with no title
    Given there is no published posts
    When I create a post with no title
    Then I have an error message "Title must not be blank"
     And no post was created
  
  Scenario: Cannot publish post with no content
    Given there is no published posts  
    When I create a post with no content
    Then I have an error message "Content is required"
     And no post was created    

  Scenario: Publishing a post
    Given there is no published posts  
    When I create a post with title "Hey there" and content "This is my first post!!!"
    Then I have an info message "Successfully published post"
     And post with title "Hey there" and content "This is my first post!!!" was created

  
