When /^I create a post with no title$/ do
  visit "/new_post"
  fill_in "body", :with => "Some body"
  click_button "submit"
end

When /^I create a post with no content$/ do
  visit "/new_post"
  fill_in "title", :with => "Some title"
  click_button "submit"
end

When /^I create a post with title "([^\"]*)" and content "([^\"]*)"$/ do |title, content|
  visit "/new_post"
  fill_in "title", :with => title
  fill_in "body", :with => content  
  click_button "submit"
end

Then /^I have an error message "([^\"]*)"$/ do |message|
  last_response.should have_xpath("//div", :id => "message", :content => message)
end

Then /^no post was created$/ do
  Post.all.size.should == 0
end

Then /^I have an info message "([^\"]*)"$/ do |message|
  last_response.should have_xpath("//div", :id => "message", :content => message)
end

Then /^post with title "([^\"]*)" and content "([^\"]*)" was created$/ do |title, content|
  Post.all(:title => title, :body => content).size.should == 1
end
