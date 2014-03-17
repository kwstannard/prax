class FileHelpGetter
  def initialize(filename)
    @filename = filename
  end

  def call
    if File.exists?(filename)
      find_help_text
      clean_help_text
      @help_text
    else
      ""
    end
  end

  private

  def find_help_text
    match = File.read(filename).match(/^# Help: (.*(^#[^\n]*))/m)
    @help_text = (match and match[1]).to_s
  end

  def clean_help_text
    @help_text.gsub!(/^# ?/, '')
  end

  def filename; @filename; end
end
