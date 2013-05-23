class Youtuber
	def initialize
		@client = YouTubeIt::Client.new(:dev_key => "AI39si4b_4STuP4zQ5J8u4o4b1G5-tG2QyzP-fYCLj4Q7vu4oA4UIJBSDV3iTvxb7Rw8p3gD7WfWs2YTJ7TKpJ5BhUI8AsTsDA")
	end

	def search(query)
		@query = @client.videos_by(:query => query)
	end

	def videos
		@query.videos.map.with_index do |video, i|
			Video.new(download_image(video.thumbnails.first.url, i), video.title, video.player_url)
		end
	end

	def download_image(url,i)
		thumbs = File.dirname(__FILE__) + "/thumbs/"
		FileUtils.mkdir_p thumbs unless File.directory? thumbs
		outname = thumbs + url.split('/')[-1].split('.').insert(-2, i.to_s).join('.')
		download(url, outname)
		outname
	end

	def download(vidlink, vidfile)
		writeOut = open(vidfile, "wb")
		writeOut.write(open(vidlink).read)
		writeOut.close
	end

	def convert(video)
		`"bin/exes/ffmpeg.exe" -i #{video} -vn -acodec pcm_s16le -ar 16000 -ac 1 -f wav #{video}.WAV`
	end

	# Thanks to Yusuf Abdulla for creating this code.
	# Original can be found at: http://www.yusufshunan.com/2011/09/youtube-video-download-scrip-ruby/
	def download_video(path)
		uri = URI.parse(path)
			open(uri) do |file|
			openedsource = file.read

			# search for the title
			vids = File.dirname(__FILE__) + "/vids/"
			FileUtils.mkdir_p vids unless File.directory? vids
			rgtitlesearch = Regexp.new(/\<meta name="title" content=.*/)
			vidtitle = rgtitlesearch.match(openedsource)
			idtitle = vidtitle[0].gsub("<meta name=\"title\" content=\"",vids).gsub("\">","").gsub(/ /,'')+".flv"
		
			# search for the download link
		  rglinksearch = Regexp.new(/,url=.*\\u0026quality=/)
		  vidlink = rglinksearch.match(openedsource)

			vidlink[0].split(",url=").each do |foundlinks|
				vidlink = foundlinks.gsub(",url=","").gsub("\\u0026quality=","").gsub("%3A",":").gsub("%2F","/").gsub("%3F","?").gsub("%3D","=").gsub("%252C",",").gsub("%253A",":").gsub("%26","&")
			end

			download(vidlink,vidtitle)
		end
	end

end

class Video
	attr_reader :img, :title, :url

	def initialize(img, title, url)
		@img = img
		@title = title
		@url = url
	end

end
