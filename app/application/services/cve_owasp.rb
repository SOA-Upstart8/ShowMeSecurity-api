# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return OWASP TOP10 category CVE
    class CVEOwasp
      include Dry::Transaction

      step :validate_input
      step :get_cve
      step :return_cve

      private

      OWASP_TOP10 = %w[injection authentication exposure xxe access
                       misconfigurations xss deserialization vulnerabilities monitoring].freeze

      # validate user query
      def validate_input(input)
        OWASP_TOP10.each do |word|
          input = input.downcase
          Success(word: word) if input.include? word
        end
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      # call search_cve(category)
      def get_cves(input)
        Success(result: CVE::Mapper::CVEMapper.new(input[:word]).filter)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def return_cve(input)
        input[:result].each do |cve|
          Success(Value::Result.new(status: :ok, message: cve))
        end
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end
    end
  end
end
