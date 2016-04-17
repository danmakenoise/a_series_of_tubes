require 'a_series_of_tubes'

ROOT_FOLDER = File.join(File.dirname(__FILE__), 'test_db')
TUBE_SQL_FILE = File.join(ROOT_FOLDER, 'cats.sql')
TUBE_DB_FILE = File.join(ROOT_FOLDER, 'cats.db')

describe ASeriesOfTubes::TubeRecord::SQLObject do
  before(:each) { ASeriesOfTubes::TubeRecord::DBConnection.reset }
  after(:each) { ASeriesOfTubes::TubeRecord::DBConnection.reset }

  context 'before ::finalize!' do
    before(:each) do
      class Cat < ASeriesOfTubes::TubeRecord::SQLObject
      end
    end

    after(:each) do
      Object.send(:remove_const, :Cat)
    end

    describe '::table_name' do
      it 'generates default name' do
        expect(Cat.table_name).to eq('cats')
      end
    end

    describe '::table_name=' do
      it 'sets table name' do
        class Human < ASeriesOfTubes::TubeRecord::SQLObject
          self.table_name = 'humans'
        end

        expect(Human.table_name).to eq('humans')

        Object.send(:remove_const, :Human)
      end
    end
  end
end
