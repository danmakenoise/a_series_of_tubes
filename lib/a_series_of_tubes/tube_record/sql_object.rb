module ASeriesOfTubes
  module TubeRecord
    class SQLObject
      def self.columns
        @columns ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
          SELECT
            *
          FROM
            #{self.table_name}
        SQL
      end

      def self.table_name
        @table_name ||= self.to_s.tableize
      end

      def self.table_name=(table_name)
        @table_name = table_name
      end
    end
  end
end
