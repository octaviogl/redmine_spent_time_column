require 'redmine'
require 'spent_time_column_query_patch'

Redmine::Plugin.register :redmine_spent_time_column do
  name 'Redmine Spent Time Column'
  author 'ogonzalez@emergya.com'
  description 'Redmine plugin to add a sortable "Time Spent" column on issue searches'
  version '0.0.1'
  requires_redmine :version_or_higher => ['1.1.0']
  url 'https://github.com/octaviogl/redmine_spent_time_column'
  author_url 'http://github.com/octaviogl/'
end
