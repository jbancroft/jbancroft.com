require 'find'

Find.find('~/FilesForHome/blog/') do |path|
  unless File.directory?(path)
    f = File.new(path)
    f.each
  end
end
