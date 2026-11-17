class Api::V1::VisitorsController < Api::V1::BaseController
    def create
      visitor_key = params[:visitor_key]
      
      # Do nothing if the frontend doesn't send a key
      return if visitor_key.blank?
  
      begin
        # Try to create a log for this key for today.
        visitor_log = VisitorLog.new(visitor_key: visitor_key, visited_at: Date.today)
  
        if visitor_log.save
          # If save is successful, it's a new unique visitor for the day.
          # Now, we increment the main SiteStat counter.
          stat = SiteStat.first_or_initialize(id: 1)
          stat.increment!(:visitor_count)
        end
        
        # Always return OK so the frontend doesn't see an error on repeat visits
        render json: { status: 'logged' }, status: :ok
  
      rescue ActiveRecord::RecordNotUnique
        # This will be triggered by our unique index.
        # It just means they already visited today. This is not an error.
        render json: { status: 'already_logged_today' }, status: :ok
      end
    end
  end