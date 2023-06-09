class BookingPolicy < ApplicationPolicy
  attr_reader :flat

  # def initialize(user, flat, booking)
  #   @user = user
  #   @flat = flat
  #   @booking = booking
  # end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user != record.flat.user
  end

  def show?
    user == record.flat.user || user == record.user
  end

  def index?
    true
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end


  def accept?
    true
  end


  def refuse?
    true
  end
end
