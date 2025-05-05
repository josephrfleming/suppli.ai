class RecommendationSessionPolicy < ApplicationPolicy
  # record-level permissions 
  def show?
    record.user_id.nil? ||                    # guest session
      (user.present? && record.user_id == user.id) ||
      user&.admin?                            # site admin
  end

  alias_method :explanation?, :show?          

  def create? = true
  def new?    = create?

  # collection scope 
  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.where(user_id: nil)              # guest sessions
             .or(scope.where(user_id: user&.id))
      end
    end
  end
end
