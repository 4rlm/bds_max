require_relative '../services/core_service'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_selected_status_core(choice_hash)
      $core_choice_hash = choice_hash
  end

  def get_selected_status_core
      $core_choice_hash
  end

  def set_selected_status_gcse(choice_hash)
    $gcse_choice_hash = choice_hash
  end

  def get_selected_status_gcse
    $gcse_choice_hash
  end

  def set_selected_status_staffer(choice_hash)
    $staffer_choice_hash = choice_hash
  end

  def get_selected_status_staffer
    $staffer_choice_hash
  end

    def set_selected_status_location(choice_hash)
      $location_choice_hash = choice_hash
    end

    def get_selected_status_location
      $location_choice_hash
    end

end
