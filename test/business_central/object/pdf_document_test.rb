# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/pdf_document_test.rb

class BusinessCentral::Object::PdfDocumentTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
    @pdf_document = @client.pdfDocument(
      company_id: @company_id,
      parent_id: '123'
    )
  end

  def test_invalid_pdf_document_parent
    assert_raises(BusinessCentral::InvalidArgumentException) do
      @client.sales_invoice_line(
        company_id: @company_id,
        parent: 'something that doesnt exist',
        parent_id: '1'
      )
    end
  end

  def test_find_all
    stub_request(:get, /pdfDocument/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              :id => "dab1b699-c590-47fe-89f8-8a4901b11d35",
              :"content@odata.media_read_link" => "https//www.f.com/companies(123456)/salesInvoices(1)/pdfDocument(1)/content"
            }
          ]
        }.to_json
      )

    response = @pdf_document.find_all
    assert_equal response.first[:"content@odata.media_read_link"],
      'https//www.f.com/companies(123456)/salesInvoices(1)/pdfDocument(1)/content'
  end

  def test_find_by_id
    test_id = 'dab1b699-c590-47fe-89f8-8a4901b11d35'
    stub_request(:get, /pdfDocument\(#{test_id}\)/)
    .to_return(
      status: 200,
      body: {
       'value':
        {
          :id => "dab1b699-c590-47fe-89f8-8a4901b11d35",
          :"content@odata.media_read_link" => "https//www.f.com/companies(123456)/salesInvoices(1)/pdfDocument(1)/content"
        }
      }.to_json
    )

    response = @pdf_document.find_by_id(test_id)
    assert_equal response[:"content@odata.media_read_link"],
      'https//www.f.com/companies(123456)/salesInvoices(1)/pdfDocument(1)/content'
  end

  def test_where
    test_filter = "id eq 'dab1b699-c590-47fe-89f8-8a4901b11d35'"
    stub_request(:get, /pdfDocument\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              :id => "dab1b699-c590-47fe-89f8-8a4901b11d35",
              :"content@odata.media_read_link" => "https//www.f.com/companies(123456)/salesInvoices(1)/pdfDocument(1)/content"
            }
          ]
        }.to_json
      )

    response = @pdf_document.where(test_filter)
    assert_equal response.first[:"content@odata.media_read_link"],
      'https//www.f.com/companies(123456)/salesInvoices(1)/pdfDocument(1)/content'
  end

  def test_get_pdf
    stub_request(:get, /pdfDocument.*\/content/)
      .to_return(
        headers: { 'Content-Type' => 'application/octet-stream' },
        status: 200,
        body: "%PDF-1.5\r\n4 0 obj\r\n<</Type /Page/Parent 3 0 R/Contents 5 0 R/MediaBox\r\n"
      )

    response = @pdf_document.get_pdf
    assert_equal response, "%PDF-1.5\r\n4 0 obj\r\n<</Type /Page/Parent 3 0 R/Contents 5 0 R/MediaBox\r\n"
  end
end
