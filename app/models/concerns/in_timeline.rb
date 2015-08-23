# app/models/concerns/in_timeline.rb
require 'active_support/concern'

module InTimeline
  extend ActiveSupport::Concern

  def description
    raise 'Override method in model'
  end

  def event
    self.class.to_s
  end
end
