# frozen_string_literal: true

module BusinessCentral
  module Object
    class PdfDocument < Base
      OBJECT = 'pdfDocument'

      OBJECT_METHODS = %i[
        get
      ].freeze

      OBJECT_PARENTS = %w[
        salesInvoices
      ].freeze

      def initialize(client, parent: 'salesInvoices', parent_id:, **args)
        return if !valid_parent?(parent)

        super(client, args)
        @parent_id = parent_id
        @parent_path << {
          path: parent,
          id: parent_id
        }
      end

      def get_pdf
        if !method_supported?(:get)
          raise BusinessCentral::NoSupportedMethod.new(:get, object_methods)
        end
        url = build_url(parent_path: @parent_path, child_path: object_name + "(#{@parent_id})/content")

        octet_request = Request.call(:get, @client, url, etag: '', params: {}) do |request|
          request['Accept'] = 'application/octet-stream'
        end
        octet_request
      end
    end
  end
end
