require "spec_helper"
 
describe "Helpers" do
  include FormattingHelpers
  
  it "should nicely format dates" do
    dates = [
        { :from => "2008-10-01T14:30:13+00:00", :to => "01 Oct 2008 14:30" },
        { :from => "2010-01-31T00:00:59+00:00", :to => "31 Jan 2010 00:00" },
        { :from => "2005-05-14T20:20:13+00:00", :to => "14 May 2005 20:20" }
    ]
    dates.each { |date| format_date(DateTime.parse(date[:from])).should == date[:to] }
  end

end