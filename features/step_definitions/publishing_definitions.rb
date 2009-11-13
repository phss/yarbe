When /^I create a post with no title$/ do
  When "I create a post with title \"\" and content \"Some content\""
end

When /^I create a post with no content$/ do
  When "I create a post with title \"Some title\" and content \"\""
end

When /^I create a post with title "([^\"]*)" and content "([^\"]*)"$/ do |title, content|
  @title = title
  @content = content
  visit "/new_post"
  fill_in "title", :with => title
  fill_in "content", :with => content  
  click_button "submit"
end

Then /^I have an error message "([^\"]*)"$/ do |message|
  last_response.should have_xpath("//div", :class => "message", :content => message)
end

Then /^I have an info message "([^\"]*)"$/ do |message|
  last_response.should have_xpath("//div", :class => "message", :content => message)
end

Then /^it repopulates the form$/ do
  last_response.should have_xpath("//input", :name => "title", :value => @title)
  last_response.should have_xpath("//textarea", :name => "content", :content => @content)  
end

Then /^no post was created$/ do
  Post.all.size.should == 0
end

Then /^post with title "([^\"]*)" and content "([^\"]*)" was created$/ do |title, content|
  Post.all(:title => title, :content => content).size.should == 1
end
