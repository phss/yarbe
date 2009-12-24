When /^I go to the admin page$/ do
  basic_auth("admin", "Demo123") # This admin credentials are the same defined in yarbe.rb configuration section 
  visit "/admin"
end

Then /^I see post listing in the following order$/ do |table|
  table.hashes.each { |entry| last_response.should have_xpath("//table/tr/td", :content => entry[:title]) }
end
