class ApplicationController < ActionController::Base
  before_action :set_gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden
    flash.now[:notice] = "You do not have permission to do that."
  end

  private

  def set_gon_user
    gon.user_id = current_user.id if current_user
  end
end
