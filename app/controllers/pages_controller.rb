class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :howitworks]

  def home
  end

  def howitworks
  end
end
