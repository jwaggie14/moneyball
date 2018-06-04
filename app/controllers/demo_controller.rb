class DemoController < ApplicationController
  def game
    redirect_to("/users/signin")
  end
end
