# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test*.rb']
  t.verbose = true
  t.warning = false
end

task :add_phrases, [:category, :file_path] do |_t, args|
  require_relative 'src/phrases'

  category = args[:category]
  file_path = args[:file_path]

  if category.nil? || file_path.nil?
    puts "Usage: rake add_phrases[category,file_path]"
    puts "Example: rake add_phrases[general,phrases.json]"
    exit 1
  end

  Jargon::Phrases.load_categories!

  phrases = Jargon::Phrases.load_phrases(file_path)
  if phrases.empty?
    puts "No phrases found in #{file_path}. Please check the file format."
    exit 1
  end

  if Jargon::Phrases.categories.key?(category)
    new_phrases = Jargon::Phrases.categories[category] + phrases
    Jargon::Phrases.categories[category] = new_phrases.uniq
    puts "Added #{phrases.size} phrases to category '#{category}'."
  else
    Jargon::Phrases.categories[category] = phrases
    puts "Created new category '#{category}' with #{phrases.size} phrases."
  end

  Jargon::Phrases.categories.each do |cat, phrs|
    JSON.dump(phrs, File.open("src/assets/jargon/#{cat}.json", 'w'))
    puts "Saved #{phrs.size} phrases to src/assets/jargon/#{cat}.json"
  end

end

task default: :test
