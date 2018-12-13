# frozen_string_literal: true

require_relative 'init.rb'
def fetch
  date = ['2018-01-01', '2018-01-16', '2018-01-31',
          '2018-02-01', '2018-02-16', '2018-02-28',
          '2018-03-01', '2018-03-16', '2018-03-31',
          '2018-04-01', '2018-04-16', '2018-04-30',
          '2018-05-01', '2018-05-16', '2018-05-31',
          '2018-06-01', '2018-06-16', '2018-06-30',
          '2018-07-01', '2018-07-16', '2018-07-31',
          '2018-08-01', '2018-08-16', '2018-08-31',
          '2018-09-01', '2018-09-16', '2018-09-30',
          '2018-10-01', '2018-10-16', '2018-10-31',
          '2018-11-01', '2018-11-16', '2018-11-30',
          '2018-12-01', '2018-12-16']
  date.each_with_index do |_, index|
    break if index == 34

    result = SMS::CVE::CVEMapper.new('50a6bccb80574d368f8ea48ebda558cb').fetch_all(date[index], date[index + 1])
    result.each do |cve|
      SMS::Repository::CVEs.create(cve)
    end
    puts "success #{index}"
  end
end

fetch
