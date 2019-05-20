require 'http'

class MetricsController < ApplicationController
  
  helper_method :get_user

  # /metrics
  def index
    @metrics = get_metrics
  end

  # /metrics/:id
  def values
    metrics = get_metrics
    # p "metrics = #{metrics}"
    @metric = metrics.find do |metric|
      id = metric['href'].split('/').last
      id == params[:id]
    end
    @users = get_users
    @metric_values = get_metric_values(@metric)

    p "@metric_values = #{@metric_values}"

    # @users.each do |user|
    #   # p "user['href'] = #{user['href']}"
    #   user['metric_values'] = @metric_values.find do |value|
    #     p "value = #{value}"
    #     # p "value[owner][href] = #{value['owner']['href']}"
    #     p "user['href'] = #{user['href']}"
    #     value['owner']['href'] == user['href']
    #   end
    # end
  end

  # /metrics/:id/edit
  def edit
    metrics = get_metrics
    @metric = metrics.fetch(params[:id].to_i)
    p "@metric = #{@metric}"

    
  end

  def get_user(url)
    user = get_user(url)
    return user
  end

  private

  # Get the list of users
  def get_users
    access_token = get_token
    headers = {:Authorization => "Bearer #{access_token}", :accept => 'application/vnd.hoopla.user-list+json'}
    response = HTTP.headers(headers).get("#{@@host}/users")
    users = JSON.parse(response.to_s)
    return users
  end

  # Get a specific user
  def get_user(url)
    access_token = get_token
    headers = {:Authorization => "Bearer #{access_token}", :accept => 'application/vnd.hoopla.user+json'}
    response = HTTP.headers(headers).get(url)
    user = JSON.parse(response.to_s)
    return user
  end

  # Get the list of metrics
  def get_metrics
    access_token = get_token
    headers = {:Authorization => "Bearer #{access_token}", :accept => 'application/vnd.hoopla.metric-list+json'}
    response = HTTP.headers(headers).get("#{@@host}/metrics")
    metrics = JSON.parse(response.to_s)
    return metrics
  end

  # Get all the metric values for the passed in url
  def get_metric_values(metric)
    # p "metric[links] = #{metric['links']}"
    # Find the link object with the name 'list_metric_values' and return just the 'href'
    link = metric['links'].find { |m| m['rel'] == 'list_metric_values' }['href']
    # p "link = #{link}"
    access_token = get_token
    headers = {:Authorization => "Bearer #{access_token}", :accept => 'application/vnd.hoopla.metric-value-list+json'}
    response = HTTP.headers(headers).get(link)
    metric_values = JSON.parse(response.to_s)
    return metric_values
  end

  # Get a specific metric
  def get_metric(url)
    access_token = get_token
    headers = {:Authorization => "Bearer #{access_token}", :accept => 'application/vnd.hoopla.metric+json'}
    response = HTTP.headers(headers).get(url)
    metric = JSON.parse(response.to_s)
    return metric
  end

end
