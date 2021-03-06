# frozen_string_literal: true

module BusinessCentral
  module Object
    class Vendor < Base
      extend BusinessCentral::Object::ObjectHelper

      OBJECT = 'vendors'

      OBJECT_VALIDATION = {
        number: {
          maximum_length: 20
        },
        display_name: {
          maximum_length: 100
        },
        phone_number: {
          maximum_length: 30
        },
        email: {
          maximum_length: 80
        },
        website: {
          maximum_length: 80
        },
        tax_registration_number: {
          maximum_length: 20
        }
      }.freeze

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      navigation :default_dimension
      navigation :picture
    end
  end
end
