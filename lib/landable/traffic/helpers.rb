module Landable
  module Traffic
    module Helpers
      def track_with_landable!
        yield and return if untracked?

        begin
          @tracker = Landable::Traffic::Tracker.for self
          @tracker.track
        rescue => e
          Rails.logger.error e
          if respond_to? :newrelic_notice_error
            newrelic_notice_error e
          end
        end

        yield

        begin
          @tracker.save
        rescue => e
          Rails.logger.error e
          if respond_to? :newrelic_notice_error
            newrelic_notice_error e
          end
        end
      end

      def untracked?
        untracked_user? || untracked_path?
      end

      def untracked_user?
        Landable.configuration.dnt_enabled && request.headers["DNT"] == "1"
      end

      def untracked_path?
        Landable.configuration.untracked_paths.include? request.fullpath
      end
    end
  end
end
