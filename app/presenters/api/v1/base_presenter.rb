module Api
  module V1
    class BasePresenter
      attr_accessor :entity, :opts

      def initialize(entity, opts = {})
        @entity = entity
        @opts = opts
      end

      def self.json(records, opts = {})
        if records.respond_to?(:length)
          records.map do |record|
            new(record, opts).to_json(opts)
          end
        else
          record = records

          new(record, opts).to_json(opts)
        end
      end

      def to_json(opts = {})
        entity.as_json(opts)
      end

      def self.to_json(records, opts = {})
        records.map do |record|
          new(record, opts).to_json(opts)
        end
      end
    end
  end
end
