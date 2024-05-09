# frozen_string_literal: true

# Mailer for sending email notifications
class UserMailer < ApplicationMailer
  default from: 'PitchWize <no-reply@sheffield.ac.uk>'

  def create_match_email(user)
    @user = user
    mail(to: 'no-reply@sheffield.ac.uk', bcc: @user.pluck(:email), subject: I18n.t('mailer.new_match_created_subject'))
  end
end
