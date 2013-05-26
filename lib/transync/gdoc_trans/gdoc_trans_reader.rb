require 'google_drive'
require_relative 'gdoc_trans'

class GdocTransReader
  attr_accessor :worksheet

  def initialize(gdoc_access, tab)
    session = GoogleDrive.login(gdoc_access['email'], gdoc_access['password'])

    worksheet_tabs = session.spreadsheet_by_key(gdoc_access['key']).worksheets
    # select the right tab from worksheet
    self.worksheet = worksheet_tabs.detect{ |w| w.title == tab }
    abort("#{tab} tab is not defined in GDoc") if self.worksheet.nil?
  end

  def build_trans_hash(language = 'en')
    trans_hash = { title: worksheet.title, language: language, translations: [] }

    key_column = GdocTrans::WORKSHEET_COLUMNS[:key]
    language_column = GdocTrans::WORKSHEET_COLUMNS[language.to_sym]

    (GdocTrans::START_ROW..worksheet.num_rows).to_a.each do |row|
      translation = { key: worksheet[row, key_column], value: worksheet[row, language_column] }
      trans_hash[:translations] << translation
    end

    trans_hash
  end

end
