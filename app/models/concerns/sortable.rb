# app/models/concerns/sortable.rb
require 'active_support/concern'

module Sortable
  extend ActiveSupport::Concern

  module ClassMethods
    def sorted(column, direction = nil)
      # Create a string to sort with (e.g. "title ASC")
      sort_string = [column, direction].reject(&:blank?).join(' ')

      # Sort table column
      if column_names.include? column
        order(sort_string)

      # Sort by virtual attribute
      # TODO: Revisit this. Could have problem if all records loaded in memory.
      else
        if direction == 'desc'
          all.sort_by(&column.to_sym).reverse
        else
          all.sort_by(&column.to_sym)
        end
      end
    end
  end
end
