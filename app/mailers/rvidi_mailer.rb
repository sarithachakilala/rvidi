class RvidiMailer < ActionMailer::Base
  default from: "jyothis.kalangi@gmail.com"

  def invite_friend(user)
    @user = user
    @url  = "http://localhost:3000/"
    mail(:to => user.email, :subject => "Welcome to My rvidi Site")
  end
end
