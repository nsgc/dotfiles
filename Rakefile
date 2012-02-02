require 'pathname'

HOME = Pathname.new(ENV['HOME'])

def ln_snf(source, *dest)
    sh 'ln', '-snf', source.to_s, *dest.map(&:to_s)
end

task :default => :all
task :all => %w(dotfiles:symlink)

namespace :dotfiles do
	  task :symlink do
	       Pathname.glob('dot.*').map(&:expand_path).map {|p|
		[p.relative_path_from(HOME), HOME + p.basename.sub(/^dot\./, '.')]
	     }.each do |from, to|
     	       ln_snf from, to
 	      end
      end
end