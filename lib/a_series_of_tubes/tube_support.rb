require_relative './tube_support/core_extensions.rb'

module ASeriesOfTubes
  module TubeSupport
  end
end

String.include ASeriesOfTubes::TubeSupport::CoreExtensions::String
