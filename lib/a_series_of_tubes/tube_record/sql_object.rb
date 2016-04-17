module ASeriesOfTubes
  module TubeRecord
    class SQLObject
      def self.table_name
        @table_name ||= self.to_s.tableize
      end

      def self.table_name=(table_name)
        @table_name = table_name
      end
    end
  end
end
