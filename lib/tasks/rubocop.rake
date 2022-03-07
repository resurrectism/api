require 'rubocop/rake_task'

namespace :lint do
  desc 'Lint project files'
  RuboCop::RakeTask.new(:check)

  desc 'Take care of fixable linting errors'
  RuboCop::RakeTask.new(:fix) do |t|
    t.options = ['-A']
  end
end
