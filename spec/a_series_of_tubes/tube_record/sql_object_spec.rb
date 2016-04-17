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

  context 'after ::finalize!' do
    before(:all) do
      class Cat < ASeriesOfTubes::TubeRecord::SQLObject
        self.finalize!
      end

      class Human < ASeriesOfTubes::TubeRecord::SQLObject
        self.table_name = 'humans'

        self.finalize!
      end
    end

    after(:all) do
      Object.send(:remove_const, :Cat)
      Object.send(:remove_const, :Human)
    end

    describe '::finalize!' do
      it 'creates getter methods for each column' do
        c = Cat.new
        expect(c.respond_to? :something).to be false
        expect(c.respond_to? :name).to be true
        expect(c.respond_to? :id).to be true
        expect(c.respond_to? :owner_id).to be true
      end

      it 'creates setter methods for each column' do
        c = Cat.new
        c.name = "Nick Diaz"
        c.id = 209
        c.owner_id = 2
        expect(c.name).to eq 'Nick Diaz'
        expect(c.id).to eq 209
        expect(c.owner_id).to eq 2
      end

      it 'created getter methods read from attributes hash' do
        c = Cat.new
        c.instance_variable_set(:@attributes, {name: "Nick Diaz"})
        expect(c.name).to eq 'Nick Diaz'
      end

      it 'created setter methods use attributes hash to store data' do
        c = Cat.new
        c.name = "Nick Diaz"

        expect(c.instance_variables).to include(:@attributes)
        expect(c.instance_variables).not_to include(:@name)
        expect(c.attributes[:name]).to eq 'Nick Diaz'
      end
    end
    
    describe '#initialize' do
      it 'calls appropriate setter method for each item in params' do
        # We have to set method expectations on the cat object *before*
        # #initialize gets called, so we use ::allocate to create a
        # blank Cat object first and then call #initialize manually.
        c = Cat.allocate

        expect(c).to receive(:name=).with('Don Frye')
        expect(c).to receive(:id=).with(100)
        expect(c).to receive(:owner_id=).with(4)

        c.send(:initialize, {name: 'Don Frye', id: 100, owner_id: 4})
      end

      it 'throws an error when given an unknown attribute' do
        expect do
          Cat.new(favorite_band: 'Anybody but The Eagles')
        end.to raise_error "unknown attribute 'favorite_band'"
      end
    end
  end
end
