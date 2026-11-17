class Api::V1::FeedbacksController < Api::V1::BaseController
    def create
      @feedback = Feedback.new(feedback_params)
  
      if @feedback.save
        render json: { status: 'Success', message: 'Feedback saved', data: @feedback }, status: :ok
      else
        render json: { status: 'Error', message: 'Feedback not saved', data: @feedback.errors }, status: :unprocessable_entity
      end
    end
  
    private
  
    def feedback_params
        params.require(:feedback).permit(:name, :email, :message)
    end
  end
  