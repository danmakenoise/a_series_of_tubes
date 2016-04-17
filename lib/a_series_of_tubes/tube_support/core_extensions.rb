module ASeriesOfTubes
  module TubeSupport
    module CoreExtensions
      module String
        def tableize
          return underscore + 's'
        end

        def underscore
          output = []

          self.chars.each_with_index do |char, index|
            output << "_" if ("A".."Z").include?(char) && index != 0
            output << char.downcase
          end

          output.join
        end
      end
    end
  end
end
