Given /^there is no published posts$/ do
  Post.all.destroy!
end

Given /^the following blog posts$/ do |table|
	Given "there is no published posts"
  table.hashes.each { |entry| Post.new(entry).save }
end

Given /^there is a post with a large content$/ do
	Given "there is no published posts"  
  Post.new(:title => "Large post", :body => ("0123456789"*200)).save
end

When /^I go to the main page$/ do
  visit "/"
end

Then /^I see an empty blog listing$/ do
  last_response.should_not have_xpath("//div", :class => 'post')
end

Then /^I see a blog list in the following order$/ do |table|
  last_response.should have_xpath("//div", :class => 'post')
  table.hashes.each_with_index do |entry, i|
    last_response.should have_xpath("//div", :id => "post#{i}") do |node|
      node.should have_xpath("//div", :class => "title", :content => entry[:title])
      node.should have_xpath("//div", :class => "blurb",  :content => entry[:body])
      node.should have_xpath("//div", :class => "published_date",  :content => entry[:published_date])
    end
  end
end
				
Then /^I see the post with large content trimmed down to 1000 chars$/ do
  last_response.should have_xpath("//div", :id => "post0") do |node|
    node.should have_xpath("//div", :class => "title", :content => "Large post")
    node.should have_xpath("//div", :class => "blurb",  :content => ("0123456789"*100) + "...")
  end
end
				
