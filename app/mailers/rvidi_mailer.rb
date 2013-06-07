class RvidiMailer < ActionMailer::Base
  default from: "qwinix.system@gmail.com"

  def invite_new_friend(to_mail, from_user)
    @user_invited = from_user
    @to_mail = to_mail
    mail(:to => @to_mail, :subject => "Welcome to My rvidi Site")
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def invite_friend_toshow(to_mail, user, show_id)
    @user = user
    @show = show_id
    @to_email = to_mail
    mail :to => to_mail, :subject => "Invited to Contribute"
  end
end
