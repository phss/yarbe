xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :'xml:lang' => 'en-US', :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.id Blog.url
  xml.title Blog.title
  xml.link :type => 'text/html', :href => Blog.url, :rel => 'alternate'
  xml.link :type => 'application/atom+xml', :href => "#{Blog.url}/feed", :rel => 'self'
  xml.subtitle Blog.subtitle
  xml.updated(@posts.first ? rfc_date(@posts.first.created_at) : rfc_date(Time.now.utc))
  @posts.each do |post|
    xml.entry do |entry|
      entry.id "#{Blog.url}/post/#{post.link}"
      entry.link :type => 'text/html', :href => "#{Blog.url}/post/#{post.link}", :rel => 'alternate'
      entry.updated rfc_date(post.created_at)
      entry.title post.title
      entry.summary post.formatted_content, :type => 'html'
      entry.content post.formatted_content, :type => 'html'
      entry.author do |author|
        author.name  Blog.author
        # author.email (Marley::Configuration.blog.email)  if Marley::Configuration.blog.email
      end
    end
  end
end