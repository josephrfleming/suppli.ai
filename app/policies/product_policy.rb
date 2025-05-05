# app/policies/product_policy.rb
class ProductPolicy < ApplicationPolicy

  # per record permissions
 
  def index?   = true                               # handled by Scope
  def show?    = true                               # anyone can view
  def create?  = user.present?                      # must be logged in
  def update?  = user.admin? || record.user == user
  def destroy? = user.admin? || record.user == user

  # record collection
  class Scope < Scope
    # Return the records the current user is allowed to see
    def resolve
      if user&.admin?
        scope.all                                   
      else
        scope.where(active: true)                   
      end
    end
  end
end
