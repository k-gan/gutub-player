
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
      row[:img] = Gdk::Pixbuf.new(song.thumb_location)
      row[:title] = song.title
      row[:url] = song.download_url
      row[:check] = false
    end
  end

end
