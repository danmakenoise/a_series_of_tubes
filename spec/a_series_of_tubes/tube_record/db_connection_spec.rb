require 'a_series_of_tubes'

ROOT_FOLDER = File.join(File.dirname(__FILE__), 'test_db')
TUBE_SQL_FILE = File.join(ROOT_FOLDER, 'cats.sql')
TUBE_DB_FILE = File.join(ROOT_FOLDER, 'cats.db')

describe ASeriesOfTubes::TubeRecord::DBConnection do
  describe '#open' do
    it 'takes a database filename and creates the file' do
      expect(ASeriesOfTubes::TubeRecord::DBConnection
        .open(TUBE_DB_FILE))
        .to be_a(SQLite3::Database)
    end
  end
end
