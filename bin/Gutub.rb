
class Gutub < SongListView

  include GladeGUI

  def show()
    load_glade(__FILE__)  #loads file, glade/Gutub.glade into @builder
    @builder["scrolledwindow1"].add_child(@builder, self)
    @builder["window1"].resize(400, 530)
    @builder["window1"].show_all
    @results = "No results yet."
    @query = "nohavica"

    set_glade_all() #populates glade controls with insance variables (i.e. Myclass.label1)
    show_window()
  end

  def search__clicked(*argv)
    @builder['results'].text = ""

    @yt = Youtuber.new
    @yt.search(@builder['query'].text)
    @yt.download_thumbs

    self.refresh @yt.videos
  end

  def getThem__clicked(*argv)
    selected = Array.new

    each_row do |row|
      selected.push @yt.videos[(row[:id]) - 1] if row[:check] == true
    end

    titles = selected.map { |v| v.title }
    VR::Dialog.message_box("You selected\n#{titles.join(",\\n ")}.")

    @yt.download_videos(selected)
    VR::Dialog.message_box("Downloaded!")
  end

end

