Given /^there is no published posts$/ do
end

When /^I go to the main page$/ do
  visit "/"
end

Then /^I see an empty blog listing$/ do
				  pending
end

Given /^the following blog posts$/ do |table|
				  # table is a Cucumber::Ast::Table
  pending
end

Then /^I see a blog list in the following order$/ do |table|
 # table is a Cucumber::Ast::Table
  pending
end
				       Given /^there is a post with a large content$/ do
				        pending
				         end
				
			        Then /^I see the post with large content trimmed down$/ do
				           pending
				           end
				
