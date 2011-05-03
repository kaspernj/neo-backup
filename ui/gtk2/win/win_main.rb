class Neobackup::Gtk2::Win_main
	def initialize(neo_gtk2)
		@neo_gtk2 = neo_gtk2
		
		@gui = Gtk::Builder.new
		@gui.add_from_file("ui/gtk2/gui/win_main.ui")
		@gui.connect_signals(){|h|method(h)}
		@gui.translate
		
		@tv_profiles = Knj::Gtk2::Tv.init(@gui["tvProfiles"], [_("ID"), _("Name")])
		@gui["tvProfiles"].columns[0].visible = false
		fill_tvProfiles
		
		drivers = []
		Knj::Fs.drivers.each do |driver|
			drivers << driver[:name].to_s
		end
		
		@cb_driver = Knj::Gtk2::Cb.init("cb" => @gui["cbDriver"], "items" => drivers)
		
		@gui["window"].show_all
	end
	
	def on_window_destroy
		Gtk.main_quit
	end
	
	def get_tvProfiles
		sel = @gui["tvProfiles"].sel
		return false if !sel or sel[0].to_i == 0
		return @neo_gtk2.ob.get(:Profile, sel[0])
	end
	
	def fill_tvProfiles
		@gui["tvProfiles"].model.clear
		@gui["tvProfiles"].append(["", _("Add new")])
		
		@neo_gtk2.ob.list(:Profile) do |profile|
			@gui["tvProfiles"].append([profile.id, profile.name])
		end
		
		form_set
	end
	
	def on_btnProfileSave_clicked
		profile = get_tvProfiles
		
		save_hash = {
			:name => @gui["txtName"].text
		}
		
		begin
			if !profile
				profile = @neo_gtk2.ob.add(:Profile, save_hash)
			else
				profile.update(save_hash)
			end
		rescue => e
			Knj::Gtk2.msgbox(e.message)
		end
		
		fill_tvProfiles
	end
	
	def on_btnProfileDelete_clicked
		profile = get_tvProfiles
		return nil if !profile
		return nil if Knj::Gtk2.msgbox(_("Do you want to delete this profile?"), "yesno") != "yes"
		@neo_gtk2.ob.delete(profile)
		fill_tvProfiles
	end
	
	def on_tvProfiles_cursor_changed
		profile = get_tvProfiles
		
		if profile
			form_set("txtName" => profile[:name])
		else
			form_set
		end
	end
	
	def form_set(hash = {})
		@gui["txtName"].text = hash["txtName"].to_s
	end
end