module ApplicationHelper
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    @title ? "#{base_title} | #{@title}" : base_title
  end

  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name, :class => 'gravatar', :gravator => options)
  end
end
