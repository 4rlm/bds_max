require_relative '../services/core_service'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_selected_status(choice)
    $choice = choice
  end

  def get_selected_status
    $choice
  end

  def set_selected_status_core(choice)
    $core_choice = choice
  end

  def get_selected_status_core
    $core_choice
  end
end
