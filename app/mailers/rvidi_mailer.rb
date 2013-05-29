class RvidiMailer < ActionMailer::Base
  default from: "jyothis.kalangi@gmail.com"

  def invite_friend(user)
    @user = user
    @url  = configatron.site_address
    mail(:to => user.email, :subject => "Welcome to My rvidi Site")
  end

  def invite_new_friend(to_mail, from_user)
    @user_invited = from_user
    mail(:to => to_mail, :subject => "Welcome to My rvidi Site")
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
end
