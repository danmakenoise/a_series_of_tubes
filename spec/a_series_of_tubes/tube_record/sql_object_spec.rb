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

    describe '::columns' do
      it 'returns a list of all column names as symbols' do
        expect(Cat.columns).to eq([:id, :name, :owner_id])
      end

      it 'only queries the DB once' do
        expect(ASeriesOfTubes::TubeRecord::DBConnection).to(
          receive(:execute2).exactly(1).times.and_call_original)
        3.times { Cat.columns }
      end
    end

    describe '#attributes' do
      it 'returns @attributes hash byref' do
        cat_attributes = {name: 'Gizmo'}
        c = Cat.new
        c.instance_variable_set('@attributes', cat_attributes)

        expect(c.attributes).to equal(cat_attributes)
      end

      it 'lazily initializes @attributes to an empty hash' do
        c = Cat.new

        expect(c.instance_variables).not_to include(:@attributes)
        expect(c.attributes).to eq({})
        expect(c.instance_variables).to include(:@attributes)
      end
    end
  end
end
