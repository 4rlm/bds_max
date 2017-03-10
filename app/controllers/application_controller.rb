require_relative '../services/core_service'

class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

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


    # ========== Detect User's Level(Role) ==========

    def basic_and_up
        unless current_user && (current_user.basic? || current_user.intermediate? || current_user.advanced? || current_user.admin?)
            flash[:alert] = "NOT AUTHORIZED [1]"
            redirect_to root_path
        end
    end

    def intermediate_and_up
        unless current_user && (current_user.intermediate? || current_user.advanced? || current_user.admin?)
            flash[:alert] = "NOT AUTHORIZED [2]"
            redirect_to root_path
        end
    end

    def advanced_and_up
        unless current_user && (current_user.advanced? || current_user.admin?)
            flash[:alert] = "NOT AUTHORIZED [3]"
            redirect_to root_path
        end
    end

    def admin_only
        unless current_user && current_user.admin?
            flash[:alert] = "NOT AUTHORIZED [4]"
            redirect_to root_path
        end
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :work_phone, :mobile_phone, :department])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :work_phone, :mobile_phone, :department])
    end
end
