# # frozen_string_literal: true

# # Mailer for sending email notifications
# class UserMailer < ApplicationMailer
#   default from: 'PitchWize <no-reply@sheffield.ac.uk>'

#   def create_match_email(user)
#     @user = user
#     mail(to: 'no-reply@sheffield.ac.uk', bcc: @user.pluck(:email), subject: I18n.t('mailer.match_created_subject'))
#   end

#   def postpone_match_email(user)
#     @user = user
#     mail(to: 'no-reply@sheffield.ac.uk', bcc: @user.pluck(:email), subject: I18n.t('mailer.match_postponed_subject'))
#   end

#   def resume_match_email(user)
#     @user = user
#     mail(to: 'no-reply@sheffield.ac.uk', bcc: @user.pluck(:email), subject: I18n.t('mailer.match_resumed_subject'))
#   end

#   def update_match_email(user)
#     @user = user
#     mail(to: 'no-reply@sheffield.ac.uk', bcc: @user.pluck(:email), subject: I18n.t('mailer.match_updated_subject'))
#   end
# end

# frozen_string_literal: true

# Mailer for sending email notifications
class UserMailer < ApplicationMailer
  default from: 'PitchWize <no-reply@sheffield.ac.uk>'

  def create_match_email(user)
    send_notification(user, I18n.t('mailer.match_created_subject'))
  end

  def postpone_match_email(user)
    send_notification(user, I18n.t('mailer.match_postponed_subject'))
  end

  def resume_match_email(user)
    send_notification(user, I18n.t('mailer.match_resumed_subject'))
  end

  def update_match_email(user)
    send_notification(user, I18n.t('mailer.match_updated_subject'))
  end

  private

  def send_notification(user, subject)
    @user = user
    mail(to: 'no-reply@sheffield.ac.uk', bcc: @user.pluck(:email), subject: subject)
  end
end
