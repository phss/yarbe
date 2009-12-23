Given /^there is no published posts$/ do
  Post.all.destroy!
end

Given /^the following blog posts$/ do |table|
	Given "there is no published posts"
  table.hashes.each { |entry| Post.new(entry).save }
end

Given /^I have a post with title "([^\"]*)" and content$/ do |title, content|
  Post.new(:title => title, :content => content).save
  @content = content
end

When /^I go to the main page$/ do
  visit "/"
end

When /^I click in the "([^\"]*)"$/ do |title|
  click_link title
end

Then /^I see an empty blog listing$/ do
  last_response.should_not have_xpath("//div", :class => 'post')
end

Then /^I see a blog list in the following order$/ do |table|
  last_response.should have_xpath("//div", :class => 'post')
  table.hashes.each_with_index do |entry, i|
    last_response.should have_xpath("//div", :id => "post#{i}") do |node|
      node.should have_xpath("//a", :class => "title", :content => entry[:title])
      node.should have_xpath("//div", :class => "summary",  :content => entry[:summary])
      node.should_not have_xpath("//div", :class => "summary",  :content => entry[:exclude_from_summary]) unless entry[:exclude_from_summary].empty?
      node.should have_xpath("//div", :class => "published_date",  :content => entry[:published_date])
    end
  end
end

Then /^I can read the post content$/ do
  last_response.should have_xpath("//div", :class => "post")
  last_response.should have_xpath("//div", :content => "This is a summary")
end
