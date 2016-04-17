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

      def self.find(id)
        result = DBConnection.execute(<<-SQL, id: id).first
          SELECT
            *
          FROM
            #{self.table_name}
          WHERE
            #{self.table_name}.id = :id
          LIMIT
            1
        SQL

        self.new(result) if result
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

      def insert
        columns = self.class.columns.drop(1)
        question_marks = (['?'] * columns.length)

        ASeriesOfTubes::TubeRecord::DBConnection.execute(<<-SQL, *attribute_values)
          INSERT INTO
            #{self.class.table_name} (#{columns.join(',')})
          VALUES
            (#{question_marks.join(',')})
        SQL

        self.id = ASeriesOfTubes::TubeRecord::DBConnection.last_insert_row_id
      end

      def update
        columns = self.class.columns
        set_values = columns.map { |attr_name| "#{attr_name} = ?" }

        ASeriesOfTubes::TubeRecord::DBConnection.execute(<<-SQL, *attribute_values)
          UPDATE
            #{self.class.table_name}
          SET
            #{set_values.join(',')}
          WHERE
            id = #{self.id}
        SQL
      end

      def save
        self.id ? self.update : self.insert
      end
    end
  end
end
