class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :masquerade_user!
  before_action :get_counts
  before_action :calculating_tap_score
  before_action :calculating_avarage_rating
  before_action :check_cvs
  before_action :get_profile_pic

  protected
      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:profile_type, :phone,:varification, :slug, :terms_of_service])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile_type, :phone, :varification, :slug])
      end

      def get_counts
        if user_signed_in?
          @service_provider_count = User.where(profile_type: "Candidate").count
          @referral_count = current_user.referrals.count
          @document_count = current_user.documents.count
          @cv_count = current_user.cvs.count
          @applicants_count = User.where(:profile_type => "Candidate").count
          if current_user.profile_type == "Candidate"
            @jobs_count = Job.all.count
          else
            @jobs_count = Job.where(:user_id => current_user).count
          end
        end
      end

      def get_cv_link
        @link_cv = Cv.all
      end
      #calculating tap score
      def calculating_tap_score
        if user_signed_in?
         if current_user.documents.empty?
           @tap_score = 4
         else
           @tap_score = 8
         end
      end
    end

  def calculating_avarage_rating
     if user_signed_in?
        @avg_review = current_user.reviews.count
      end
    end

  def check_cvs
    if user_signed_in?
      @get_cvs = Cv.all
    end

    def get_profile_pic
        if user_signed_in?
          @display_pic = current_user.cvs.find_by(params[:avatar]) if Cv.present?
    end
    end
  end

end
