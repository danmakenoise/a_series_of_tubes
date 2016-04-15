require 'a_series_of_tubes'

describe ASeriesOfTubes::TubeSupport do
  describe "Monkey Patches" do
    it 'adds String.underscore' do
      expect("").to respond_to(:underscore)
    end
  end

  describe 'String#underscore' do
    it 'separates a string with underscores added before capitals' do
      expect("bbAbbA".underscore).to eq "bb_abb_a"
    end

    it 'converts everything to downcase' do
      expect("bbAbbA".underscore.downcase).to eq "bbAbbA".underscore
    end
  end
end
