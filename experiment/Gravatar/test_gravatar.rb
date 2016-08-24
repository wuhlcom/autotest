require 'digest'
module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user) #user is a Active Record obj
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}" #·µ»ØÍ¼Æ¬Á´½Ó
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def gravatar_email(email)
    gravatar_id = Digest::MD5::hexdigest(email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}" #·µ»ØÍ¼Æ¬Á´½Ó
  end
end

if $0==__FILE__
  include UsersHelper
  email = "378433855@qq.com"
gravatar_email(email)
end