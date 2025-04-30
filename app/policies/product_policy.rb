# app/policies/product_policy.rb
class ProductPolicy < ApplicationPolicy
  # --------------------------------------------
  # 🔒 PER‑RECORD PERMISSIONS
  # --------------------------------------------
  def index?   = true                               # handled by Scope
  def show?    = true                               # anyone can view
  def create?  = user.present?                      # must be logged in
  def update?  = user.admin? || record.user == user
  def destroy? = user.admin? || record.user == user

  # --------------------------------------------
  # 🔍 RECORD COLLECTION (called by policy_scope)
  # --------------------------------------------
  class Scope < Scope
    # Return the records the current user is allowed to see
    def resolve
      if user&.admin?
        scope.all                                   # admins see everything
      else
        scope.where(active: true)                   # others see only active
      end
    end
  end
end
