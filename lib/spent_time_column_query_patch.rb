# Based on http://github.com/edavis10/question_plugin/blob/master/lib/question_query_patch.rb
Dispatcher.to_prepare do
#ActionDispatch::Callbacks.to_prepare do
  require_dependency 'query'
  Query.send(:include, SpentTimeQueryPatch)
  require_dependency 'issue'
  Issue.send(:include, SpentTimeIssuePatch)
end

module SpentTimeQueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      base.add_available_column(QueryColumn.new(:spent_hours, :sortable => "(select sum(hours) from #{TimeEntry.table_name} where #{TimeEntry.table_name}.issue_id = #{Issue.table_name}.id)"))
    end

  end

  module ClassMethods
    unless Query.respond_to?(:available_columns=)
      # Setter for +available_columns+ that isn't provided by the core.
      def available_columns=(v)
        self.available_columns = (v)
      end
    end

    unless Query.respond_to?(:add_available_column)
      # Method to add a column to the +available_columns+ that isn't provided by the core.
      def add_available_column(column)
        self.available_columns << (column)
      end
    end
  end
end

module SpentTimeIssuePatch
  def spent_hours
    @spent_hours ||= (time_entries.sum(:hours)*100).round.to_f / 100 || 0
  end
end
