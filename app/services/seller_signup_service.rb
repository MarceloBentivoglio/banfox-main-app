class SellerSignupService
  attr_reader :input_data, :current_user, :step, :seller

  def initialize(step, current_user, input_data)
    @step = step
    @input_data = input_data
    @current_user = current_user
    @current_user.seller ||= Seller.new
  end

  def call
    current_user.seller.validation_status = step.to_s
    current_user.seller.update_attributes(input_data) unless input_data.nil?

    case @step
    when :basic
      basic_step(@input_data)
    when :consent
      consent_step(@input_data)
    end

    current_user.seller
  end

  def basic_step(input_data)
    current_user.save
    if current_user.seller.valid?
      SellerAnalysisJob.perform_later(current_user.id)
    end
  end

  def consent_step(input_data)
    #Now, just by getting in the last step, we have a confirmation that the user agreed by all rules in the website
    #The validation_status: active means that the process of signup is finished
    current_user.seller.update_attributes(
      validation_status: 'active',
      consent: true
    )
  end
end
