class Api::FeedController < ApplicationController
  rescue_from Api::Errors::Base, with: :handle_error
  GET_MICROPOSTS_IN_FEED = 10

  def index
    feed = current_user.feed.limit(GET_MICROPOSTS_IN_FEED).offset(GET_MICROPOSTS_IN_FEED * params[:page].to_i)
    user_ids = []
    feed.map { |micropost| user_ids << micropost.user_id unless user_ids.include?(micropost.user_id) }
    feed_users = User.select("id, name").where(id: user_ids)
    render json: {feed: feed, users: feed_users}
  end

  private

    def handle_error(error)
      render json: {message: error.detail}, status: error.status_code
    end

end
