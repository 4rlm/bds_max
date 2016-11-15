class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_selected_status(choice)
    $choice = choice
  end

  def get_selected_status
    $choice
  end
end
