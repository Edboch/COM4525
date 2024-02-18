# frozen_string_literal: true

# Base class for all mailers
class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@sheffield.ac.uk'
  layout 'mailer'
end
