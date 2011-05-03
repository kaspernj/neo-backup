#!/usr/bin/env ruby

require "knj/autoload"
require "knj/gtk2"

Dir.chdir(File.dirname(__FILE__))

require "lib/autoinclude.rb"

class Neobackup::Gtk2
	attr_reader :neo
	
	def initialize(neo)
		@neo = neo
		
		#Make all windows autoloadable.
		Dir.new("ui/gtk2/win").each do |file|
			next if !match = file.match(/^win_([A-z]+)\.rb$/)
			class_name = "Win_#{match[1]}".to_sym
			autoload class_name, "ui/gtk2/win/#{file}"
		end
		
		@win_main = Neobackup::Gtk2::Win_main.new(self)
	end
	
	def db
		return @neo.db
	end
	
	def ob
		return @neo.ob
	end
end

Neobackup::Gtk2.new($neo)

Gtk.main