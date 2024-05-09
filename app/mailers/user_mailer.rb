class UserMailer < ApplicationMailer
  default from: 'PitchWize <no-reply@sheffield.ac.uk>'

  def create_match_email(user)
    @user = user
    mail(to: 'no-reply@sheffield.ac.uk', bcc: @user.email, subject: 'New Match Created')
  end

end
