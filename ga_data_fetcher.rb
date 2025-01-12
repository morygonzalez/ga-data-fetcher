require 'bundler/setup'
require 'dotenv/load'
require 'google/analytics/data/v1beta'

class GaDataFetcher
  GA = Google::Analytics::Data::V1beta

  def initialize(start_date:, end_date:, metrics_names: nil, dimension_names: nil)
    @start_date = start_date
    @end_date = end_date
    @metrics_names = metrics_names || ['screenPageViews', 'totalUsers']
    @dimension_names = dimension_names || ['pageTitle', 'pagePath']
  end

  def client
    @client ||= GA::AnalyticsData::Client.new
  end

  def metrics
    @metrics ||= @metrics_names.each_with_object([]) do |name, result|
      result << GA::Metric.new(name: name)
    end
  end

  def dimensions
    @dimensions ||= @dimension_names.each_with_object([]) do |name, result|
      result << GA::Dimension.new(name: name)
    end
  end

  def date_range
    @date_range ||= GA::DateRange.new(start_date: @start_date, end_date: @end_date)
  end

  def dimension_filter
    @dimension_filter ||= GA::FilterExpression.new(
      not_expression: {
        filter: {
          field_name: 'pagePath',
          string_filter: {
            match_type: 'FULL_REGEXP',
            value: '^/(archives|categories|about|morygonzalez|popular)?$'
          }
        }
      }
    )
  end

  def request
    GA::RunReportRequest.new(
      property: 'properties/311948350',
      metrics: metrics,
      dimensions: dimensions,
      date_ranges: [date_range],
      dimension_filter: dimension_filter,
      limit: 30
    )
  end

  def response
    client.run_report(request)
  end
end
