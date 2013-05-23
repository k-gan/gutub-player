##
# This class contains all the code for the ListView itself.
# It sets-up the columns and data.
# The GUI class will make changes to the view/data.
# All the GUI code is in SongListViewGUI.rb.  
#

class SongListView < VR::ListView

	def initialize 
		@cols = {}
		@cols[:id] = Integer
		@cols[:song] = { :img => Gdk::Pixbuf, :title => String }
		@cols[:check] = TrueClass
		@cols[:url] = String
		super(@cols)
		col_visible(:url => false)
		col_width(:id => 25, :title => 310, :check => 40)
	end		

	# this just loads the data into the model
	def refresh data
		self.model.clear
		data.each_with_index do |song, i|
			row = add_row()
  		row[:id] = (i + 1)
			row[:img] = Gdk::Pixbuf.new(song.img)
  		row[:title] = song.title
			row[:url] = song.url
  		row[:check] = false
		end
	end

end
