Feature: Administering posts
  In order manage my posts
  As an admin/author
  I want administer them
  
  Scenario: Viewing posts
    Given the following blog posts
      | title            | created_at                | content                     |
      | Some post        | 2008-10-01T14:30:13+00:00 | This is some content        |
      | Another post     | 2009-02-13T10:10:53+00:00 | This is another content     | 
      | Yet another post | 2007-07-30T15:00:00+00:00 | This is yet another content |    
      | With summary     | 1997-09-05T13:00:00+00:00 | Summary before heading<h2>A heading</h2>After heading |                 
    When I go to the admin page
    Then I see post listing in the following order
      | title            |
      | Another post     |
      | Some post        |
      | Yet another post |
      | With summary     |

  
  
  
      
  
