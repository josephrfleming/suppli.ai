# app/controllers/home_controller.rb
class HomeController < ApplicationController
  # no login required for the public landing page
  skip_before_action :authenticate_user!, only: :index

  def index
    @title   = "Suppli Ai"
    @content = "<p>Welcome! Log in or register to begin.</p>"
  end
end
