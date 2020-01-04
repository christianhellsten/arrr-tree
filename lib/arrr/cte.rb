require "arrr/cte/version"

module Arrr
  # CTE queries for ActiveRecord / Rails
  #
  # class Node < ApplicationRecord
  #   include Arrr::Cte
  # end
  #
  module Cte
    extend ActiveSupport::Concern

    included do
      belongs_to :parent, class_name: name, required: false
      has_many :children, class_name: name, foreign_key: :parent_id
      scope :roots, -> { where(parent_id: nil) }
    end

    def root
      ancestors.find_by!(parent_id: nil)
    end

    def ancestors(columns = self.class.column_names)
      cols = columns.join(', ')
      child_id = ActiveRecord::Base.connection.quote(id)
      self.class.from <<~SQL
        (WITH RECURSIVE tree(#{cols}, path) AS (
          SELECT
            #{cols}, ARRAY[id]
          FROM
            #{self.class.table_name}
          WHERE
            id = #{child_id}
        UNION ALL
          SELECT
            #{columns.map { |col| "#{self.class.table_name}.#{col}" }.join(', ')}, path || #{self.class.table_name}.id
          FROM
            tree
          JOIN
            #{self.class.table_name} ON tree.parent_id = #{self.class.table_name}.id
          WHERE NOT
            #{self.class.table_name}.id = ANY(path) -- avoid infinite loops where e.g. parent = self
        ) SELECT #{cols} FROM tree WHERE id != #{child_id}) as #{self.class.table_name}
      SQL
    end

    def descendants
      self_and_descendants.where('id != ?', id)
    end

    def self_and_descendants(columns = self.class.column_names)
      cols = columns.join(', ')
      root_id = ActiveRecord::Base.connection.quote(id)
      self.class.from <<~SQL
        (WITH RECURSIVE tree(#{cols}, path) AS (
          SELECT
            #{cols}, ARRAY[id]
          FROM
            #{self.class.table_name}
          WHERE
            id = #{root_id}
        UNION ALL
          SELECT
            #{columns.map { |col| "#{self.class.table_name}.#{col}" }.join(', ')}, path || #{self.class.table_name}.id
          FROM
            tree
          JOIN
            #{self.class.table_name} ON #{self.class.table_name}.parent_id = tree.id
          WHERE NOT
            #{self.class.table_name}.id = ANY(path) -- avoid infinite loops where e.g. parent = self
        ) SELECT #{cols} FROM tree as #{self.class.table_name}
      SQL
    end
  end
end
