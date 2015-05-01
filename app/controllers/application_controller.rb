class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :sort_by, :sort_in

  private

  def sorted?
    params[:sort_by].present?
  end

  def sort_by
    params[:sort_by]
  end

  def sort_in
    params[:sort_in] || "asc"
  end
end
