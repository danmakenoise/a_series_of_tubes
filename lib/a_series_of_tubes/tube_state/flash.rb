require 'json'

module ASeriesOfTubes
  module TubeState
    class Flash
      attr_reader :now, :next

      def initialize existing_flash_data = {}
        @store = existing_flash_data
        @next = {}
      end

      def [] key
        self.store[key]
      end

      def []= key, value
        self.next[key] = value
      end

      def now
        self.store
      end

      protected
      attr_reader :store
    end
  end
end
