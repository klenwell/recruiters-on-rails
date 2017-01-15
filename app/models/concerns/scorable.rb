# app/models/concerns/scorable.rb
require 'active_support/concern'

module Scorable
  extend ActiveSupport::Concern

  included do
    after_save :update_recruiter_score
  end

  def update_recruiter_score
    return unless recruiter
    recruiter.force_rescore
    recruiter.save!
  end
end
