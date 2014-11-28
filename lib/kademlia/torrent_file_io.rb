require_relative 'torrent_writer'
require_relative 'torrent_reader'

class TorrentFileIO
  def initialize(metainfo, file_name = nil)
    @metainfo = metainfo
    file_name = metainfo.info.name unless file_name
    initialize_file(file_name)

    @writer = TorrentWriter.new(metainfo, file_name)
    @reader = TorrentReader.new(metainfo, file_name)
  end

  def write(piece)
    @writer.write(piece)
  end

  def read(idx, bgn, length)
    @reader.read(idx, bgn, length)
  end

  private

  def initialize_file(file_name)
    unless (File.exists?(file_name))
      size = @metainfo.info.length
      File.open(file_name,"wb") { |f| f.seek(size-1); f.write("\0"); f.close}
    end
  end
end
