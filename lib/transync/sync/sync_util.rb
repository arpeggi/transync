require 'logger'
require_relative '../xliff_trans/xliff_trans_reader'

module SyncUtil

  def self.check_and_get_xliff_files(languages, path, file, create = false)
    xliff_translations = []
    added = false

    languages.each do |language|
      xliff_reader = XliffTransReader.new(path, file, language, languages)
      if xliff_reader.valid?(create)
        xliff_translations << xliff_reader.get_translations
      else
        added = true if create
        abort('Fix your Xliff translations first!') unless create
      end
    end

    p 'Missing translations were added!' if create and added

    xliff_translations
  end

  def self.info_clean(file, language, message)
    msg = "#{file} (#{language}) - #{message}"
    SyncUtil.log_and_puts(msg)
  end

  def self.info_diff(file, language, operation, trans)
    msg = "#{file} (#{language}) - #{operation}: '#{trans[:key]}' => '#{trans[:value]}'"
    SyncUtil.log_and_puts(msg)
  end

  def self.log_and_puts(msg)
    p msg
    @logger.info msg
  end

  def self.create_logger(direction)
    # gdoc2xliff or xliff2gdoc
    @logger = Logger.new(".transync_log/#{direction}.log", 'monthly')
  end

end
