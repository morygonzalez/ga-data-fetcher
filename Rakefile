require_relative 'ga_data_fetcher'
require 'csv'

namespace :ga_data_fetch do
  desc "Fetch recent 30 days'"
  task :recent_30_days do
    start_date = '30daysAgo'
    end_date = 'yesterday'
    get_csv(start_date, end_date)
  end

  desc "Fetch yesterday's"
  task :yesterday do
    start_date = 'yesterday'
    end_date = 'yesterday'
    get_csv(start_date, end_date)
  end

  desc "Fetch today's"
  task :today do
    start_date = 'today'
    end_date = 'today'
    get_csv(start_date, end_date)
  end
end

def get_csv(start_date, end_date)
  fetcher = GaDataFetcher.new(start_date: start_date, end_date: end_date)
  response = fetcher.response.to_h
  headers = (response[:dimension_headers] + response[:metric_headers]).map {|item| item[:name] }
  rows = response.dig(:rows).map {|row|
    CSV::Row.new(
      headers,
      row.flatten.flatten.delete_if {|item| item.is_a?(Symbol) }.map {|item| item[:value] }
    )
  }
  table = CSV::Table.new(rows)
  puts table.by_col['pagePath'].map.with_index {|item, index|
    %(#{table.by_col['screenPageViews'][index]}\s#{item}\n)
  }
end
