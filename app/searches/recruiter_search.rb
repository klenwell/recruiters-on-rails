class RecruiterSearch < Searchlight::Search

  search_on Recruiter.all

  searches :name_like, :typeahead

  def search_name_like
    search.where("email ILIKE ?", "%#{name_like}%")
  end

  def search_typeahead
    search.where("email ILIKE ?", "%#{typeahead}%")
  end

end
