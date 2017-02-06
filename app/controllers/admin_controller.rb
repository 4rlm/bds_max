class AdminController < ApplicationController
    def index
        @pending_users =  User.where(role: "pending")
        @basic_users =  User.where(role: "basic")
        @intermediate_users =  User.where(role: "intermediate")
        @advanced_users =  User.where(role: "advanced")
        @admin_users =  User.where(role: "admin")
    end
end
