module UsersHelper

  # returns the Gravatar for a given user
  # Gravatar URLs are based on MD5 hash which is a cryptographic hash function value.
  # MD5 hashing algorithm in Ruby is implemented using hexdigest method
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")  #returns the image tag here which is used in show.html.erb
  end
end
