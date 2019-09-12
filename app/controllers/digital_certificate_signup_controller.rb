class DigitalCertificateSignupController < ApplicationController
  skip_before_action :require_active
  skip_before_action :require_permission_to_operate
  skip_before_action :require_not_on_going

  layout "empty_layout"

  def how_digital_certificate_works
  end

end
