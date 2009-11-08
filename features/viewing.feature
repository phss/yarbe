Feature: Viewing posts
  In order to learn stuff
  As a reader
  I want view and read posts
  
  Scenario: Viewing blog list with no posts
    Given there is no published posts
    When I go to the main page
    Then I see an empty blog listing
    
  Scenario: View blog list
    Given the following blog posts
      | title            | date                | content                     |
      | Some post        | 2008 10 01 14 30 13 | This is some content        |
      | Another post     | 2009 02 13 10 10 53 | This is another content     | 
      | Yet another post | 2007 07 30 15 00 00 | This is yet another content |           
    When I go to the main page
    Then I see a blog list in the following order
      | title            | date                | content                     |
      | Another post     | 13 Feb 2009 10:10   | This is another content     |       
      | Some post        | 1 Oct 2008 14:30    | This is some content        |
      | Yet another post | 30 Jul 2007 15:00   | This is yet another content |      

  Scenario: Posts with large content are trimmed
    Given there is a post with a large content
    When I go to the main page
    Then I see the post with large content trimmed down 
  
  
  