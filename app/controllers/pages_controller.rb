class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :howitworks]

  def home
    render layout: "homelayout"
  end

  def howitworks
    render layout: "homelayout"
  end
end
