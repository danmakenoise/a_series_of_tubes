require 'byebug'

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

      def self.all
        self.parse_all(DBConnection.execute(<<-SQL))
          SELECT
            *
          FROM
            #{self.table_name}
        SQL
      end

      def self.parse_all(results)
        results.map { |params| self.new(params) }
      end

      def self.finalize!
        self.columns.each do |column|
          define_method(column) { self.attributes[column] }
          define_method("#{column}=") { |value| self.attributes[column] = value }
        end
      end

      def self.table_name
        @table_name ||= self.to_s.tableize
      end

      def self.table_name=(table_name)
        @table_name = table_name
      end

      def initialize(params = {})
        params.each do |attr_name, value|
          if self.class.columns.include?(attr_name.to_sym)
            self.send("#{attr_name}=", value)
          else
            raise "unknown attribute '#{attr_name}'"
          end
        end
      end

      def attributes
        @attributes ||= {}
      end

      def attribute_values
        @attributes.keys.map { |k| @attributes[k] }
      end
    end
  end
end
