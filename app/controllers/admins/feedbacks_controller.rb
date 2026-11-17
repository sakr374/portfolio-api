class Admins::FeedbacksController < ApplicationController
    before_action :authenticate_admin!
  
    def index
      @feedbacks = Feedback.all.order(created_at: :desc)
      render json: @feedbacks, status: :ok
    end
  end