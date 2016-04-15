require 'spec_helper'

describe ASeriesOfTubes do
  it 'has a version number' do
    expect(ASeriesOfTubes::VERSION).not_to be nil
  end

  it 'includes Tubes' do
    expect(ASeriesOfTubes::Tubes).to be_a(Module)
  end

  it 'includes TubeState' do
    expect(ASeriesOfTubes::TubeState).to be_a(Module)
  end

  it 'includes TubeSupport' do
    expect(ASeriesOfTubes::TubeSupport).to be_a(Module)
  end

  it 'includes TubeController' do
    expect(ASeriesOfTubes::TubeController).to be_a(Class)
  end
end
