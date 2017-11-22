require "searchlight/adapters/action_view"

class RecruiterSearch < Searchlight::Search
  include Searchlight::Adapters::ActionView

  def base_query
    Recruiter.all
  end

  def search_name_like
    query.where("email ILIKE ?", "%#{name_like}%")
  end

  def search_typeahead
    query.where("email ILIKE ?", "%#{typeahead}%")
  end

end
