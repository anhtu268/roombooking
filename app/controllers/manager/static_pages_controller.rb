module Manager
  class StaticPagesController < Manager::ApplicationController
    def home
      @locations= current_user.locations.includes(:location_type).page(params[:page]).per(Settings.page).decorate
    end
  end
end
