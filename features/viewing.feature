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
      | title            | created_at                | content                     |
      | Some post        | 2008-10-01T14:30:13+00:00 | This is some content        |
      | Another post     | 2009-02-13T10:10:53+00:00 | This is another content     | 
      | Yet another post | 2007-07-30T15:00:00+00:00 | This is yet another content |    
      | With summary     | 1997-09-05T13:00:00+00:00 | Summary before heading<h2>A heading</h2>After heading |                 
    When I go to the main page
    Then I see a blog list in the following order
      | title            | published_date      | summary                     | exclude_from_summary |
      | Another post     | 13 Feb 2009 10:10   | This is another content     |                      |
      | Some post        | 1 Oct 2008 14:30    | This is some content        |                      |
      | Yet another post | 30 Jul 2007 15:00   | This is yet another content |                      |
      | With summary     | 5 Sep 1997 13:00    | Summary before heading      | After heading        |

  Scenario: View a blog post
    Given I have a post with title "The post title" and content
      """
        This is a summary.
        
        Real stuff here
        ---------------
        
        I should be able to read this when I view the blog post.
      """
    When I go to the main page
     And I click in the "the_post_title"
    Then I can read the post content
      
  
  