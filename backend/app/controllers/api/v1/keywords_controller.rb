class Api::V1::KeywordsController < ApplicationController
  before_action :find_keyword,       only: [:show]

  def index
    keywords = Keyword.where(filter)
      .where(user_id: current_user.id)
      .limit(limit)
      .order(order_list)
      .offset(offset)
      .as_json

    render_ok(count: keywords.size, keywords:)
  end

  def show
    render_ok(keyword: @keyword.as_json)
  end

  private

  def find_keyword
    @keyword = Keyword.find_by(id: params[:id])
    render_not_found unless @keyword
  end

  def order_list
    order_query = nil

    if params[:updated_at].present?
      order_query = "updated_at #{params[:updated_at].upcase}"
    else
      order_query = "created_at #{params[:created_at] || 'DESC'}"
    end

    order_query
  end

  def filter
    return {} if params[:query].blank?

    [
      'keywords.word'
    ].map { |attr| "#{attr} LIKE '%#{Keyword.sanitize_sql_like(params[:query].strip)}%'" }.join(' OR ')
  end
end
