#!/usr/bin/env ruby

require "knj/autoload"
Dir.chdir(Knj::Php.realpath("#{File.dirname(__FILE__)}/../"))
require "lib/autoinclude"

Knj::Php.die("knjdbrevision path not given in arguments.\n") if !ARGV[0]
Knj::Php.die("knjdbrevision path not found.\n") if !File.exists?(ARGV[0])

recipe_path = Knj::Php.realpath("db/knjdbrevision_recipe.rb")
Knj::Php.die("recipe could not be found.\n") if !recipe_path or !File.exists?(recipe_path)

knjdbrev = ARGV[0]
cmd = "ruby1.9.1 #{Knj::Strings.unixsafe(knjdbrev)} -r #{Knj::Strings.unixsafe(recipe_path)}"

$neo.db.opts.each do |key, val|
	if key.to_s == "path" and val.to_s == "db/neo-backup.sqlite3"
		val = Knj::Php.realpath("#{File.dirname(__FILE__)}/") + "/#{val}"
	end
	
	cmd += " -d \"#{key}=#{val}\""
end

exec(cmd)