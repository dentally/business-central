# frozen_string_literal: true

module BusinessCentral
  module Object
    class URLBuilder
      extend URLHelper

      class << self
        def sanitize(query = '', values = [])
          return encode_url_params(query) if values.length.zero?

          query = replace_template_with_value(query, values)
          encode_url_object(query)
        end
      end

      def initialize(base_url:, parent_path: [], child_path: '', child_id: '', child_code: '', microsoft_nav: '', filter: '')
        @base_url = base_url.to_s
        @parent_path = parent_path || []
        @child_path = child_path.to_s
        @child_id = child_id.to_s
        @child_code = child_code.to_s
        @microsoft_nav = microsoft_nav.to_s
        @filter = filter.to_s
      end

      def build
        url = @base_url
        url += build_parent_path
        url += build_child_path
        url += build_microsoft_nav_path
        url += build_filter
        url
      end

      private

      def build_parent_path
        return '' if @parent_path.empty?

        @parent_path.map do |parent|
          "/#{parent[:path]}(#{parent[:id]})" if !parent[:id].nil?
        end.join('')
      end

      def build_child_path
        url = ''
        url += "/#{@child_path}" if @child_path.present?
        url += "(#{@child_id})" if @child_id.present?
        url += "('#{odata_encode(@child_code)}')" if @child_code.present?
        url
      end

      def build_microsoft_nav_path
        url = ''
        url += "/Microsoft.NAV.#{@microsoft_nav}" if @microsoft_nav.present?
        url
      end

      def build_filter
        url = ''
        url += "?$filter=#{@filter}" if @filter.present?
        url
      end
    end
  end
end
