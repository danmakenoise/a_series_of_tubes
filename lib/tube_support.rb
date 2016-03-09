require_relative './tube_support/core_extensions.rb'

module TubeSupport
  include CoreExtensions
end

String.include TubeSupport::CoreExtensions::String
