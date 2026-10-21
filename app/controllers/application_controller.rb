class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

    def current_user
      # The task requires us to assume login and auth already exist. Thus, I'm
      # setting current_user in place of Devise or another login/auth package
      @current_user ||= User.find_by(id: params[:user_id])
    end
end
