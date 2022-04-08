class TweetsController < ApplicationController
  def index
    render json: Tweet.order('created_at DESC').limit(5).offset(page_offset)
  end

  private

  def page_offset
    (tweets_params[:page].to_i - 1) * 5
  end

  def tweets_params
    params.permit(:page)
  end
end
