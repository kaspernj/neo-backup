class Neobackup
	attr_accessor :db, :ob
	
	def initialize(args)
		@args = args
		@db = @args[:db]
		
		@ob = Knj::Objects.new(
			:db => @db,
			:class_path => Knj::Php.realpath(File.dirname(__FILE__)),
			:module => Neobackup,
			:datarow => true
		)
	end
end

ENV["LANGUAGE"] = "da_DK"
GetText.bindtextdomain("default", Knj::Php.realpath(File.dirname(__FILE__) + "/../locales"))

def _(str)
	return GetText.gettext(str.to_s)
end

require "configs/database"

$neo = Neobackup.new(:db => $neo_db)
