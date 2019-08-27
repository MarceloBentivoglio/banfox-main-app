class Api::V1::Stone::ClientsController < Api::V1::BaseController
  skip_after_action :verify_authorized

  def welcome
    head :ok
  end

  def update
    head :ok
  end
end
