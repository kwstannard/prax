class FileUsageGetter
  def initialize(filename)
    @filename = filename
  end

  def call
    if File.exists?(filename)
      if match = /^# (Usage: .*)/.match(File.read(filename))
        return match[1].to_s
      end
    end
    "Sorry, this command's usage isn't documented yet."
  end

  private

  def filename; @filename; end
end
