class Youtuber
  attr_reader :videos

  def initialize
    @client = YouTubeIt::Client.new(:dev_key => "AI39si4b_4STuP4zQ5J8u4o4b1G5-tG2QyzP-fYCLj4Q7vu4oA4UIJBSDV3iTvxb7Rw8p3gD7WfWs2YTJ7TKpJ5BhUI8AsTsDA")
  end

  def search(query)
    @query = @client.videos_by(:query => query)
    @videos = @query.videos.map do |video|
      yt_vid = OpenStruct.new

      yt_vid.title = video.title
      yt_vid.player_url = video.player_url
      yt_vid.duration = video.duration
      yt_vid.thumb_url = video.thumbnails.first.url

      yt_vid
    end
  end

  # Some ideas for the method to check available formats of a video.
  # Some ideas from here will also be needed to determine the download
  # link.
  # Right now it does a lot of things and nothing interesting/needed.
  def check_formats(yt_vid)
    formats_query = `quvi -F #{selected.player_url}`

    formats = formats_query.slice(0..(formats_query.index(' :'))).split("|")

    yt_vid.formats = get_filesize(yt_vid.player_url, formats)
    doc = Nokogiri.parse(`quvi --xml #{video.player_url}`)

    yt_vid.title = doc.at('page_title').text
    yt_vid.download_url = CGI::unescape(doc.at('url').text)
    yt_vid.player_url = video.player_url
    yt_vid.duration = doc.at('duration').text
    yt_vid.thumb_url = CGI::unescape(doc.at('thumbnail_url').text)
  end

  # Checks the filesize of a video in a particular format.
  # Right now is not used anywhere. But will, surely.
  def get_filesize(url, format)
    to_parse = `quvi --xml --format #{format} #{url}`
    parsed = Nokogiri.parse(to_parse)
    parsed.at('length_bytes').text
  end

  def download_thumbs
    thumbs = File.dirname(__FILE__) + "/thumbs/"
    FileUtils.mkdir_p thumbs unless File.directory? thumbs
    @videos.each_with_index do |video, i|
      outname = thumbs + video.thumb_url.split('/')[-1].split('.').insert(-2, i.to_s).join('.')
      video.thumb_location = outname

      download(video.thumb_url, outname)
    end
  end

  def download(vidlink, vidfile)
    writeOut = open(vidfile, "wb")
    writeOut.write(open(vidlink).read)
    writeOut.close
  end

  def download_videos(videos)
    # stub
  end

end
