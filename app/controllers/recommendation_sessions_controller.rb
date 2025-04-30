# app/controllers/recommendation_sessions_controller.rb
class RecommendationSessionsController < ApplicationController
  # guests can view, not modify
  skip_before_action :authenticate_user!, only: %i[index new create show explanation]
  before_action :set_session, only: %i[show explanation]

  # GET /recommendation_sessions — list previous sessions
  def index
    @sessions =
      if user_signed_in?
        RecommendationSession.where(user: current_user).order(created_at: :desc)
      else
        []
      end
  end

  # GET /recommendation_sessions/new — show intake form
  def new
    @session = RecommendationSession.new(budget: 80)
  end

  # POST /recommendation_sessions — save & generate plan
  def create
    @session = RecommendationSession.new(session_params)
    @session.user = current_user if user_signed_in?

    if @session.save
      begin
        @session.update!(result_json: AiRecommender.new(@session).recommend)
        notice = "Your personalized plan is ready!"
      rescue => e
        Rails.logger.warn "AI error: #{e.class} – #{e.message}"
        notice = "Generating recommendations — please refresh in a moment."
      end
      redirect_to @session, notice: notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /recommendation_sessions/:id — view saved results
  def show; end

  # GET /recommendation_sessions/:id/explanation — view/generate explanation
  def explanation
    unless @session.explanation.present?
      @session.update!(explanation: AiExplanationService.call(@session))
    end
    # renders explanation view
  end

  private

  def set_session
    scope    = defined?(Pundit) ? policy_scope(RecommendationSession) : RecommendationSession
    @session = scope.find(params[:id])
    authorize @session if defined?(Pundit)
  end

  def session_params
    params.require(:recommendation_session).permit(
      :budget, :notes,
      area_of_interest: [], dietary_restrictions: []
    )
  end
end
