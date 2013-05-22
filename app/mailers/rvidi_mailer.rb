class RvidiMailer < ActionMailer::Base
  default from: "jyothis.kalangi@gmail.com"

  def invite_friend(user)
    @user = user
    @url  = configatron.site_address
    mail(:to => user.email, :subject => "Welcome to My rvidi Site")
  end
end
