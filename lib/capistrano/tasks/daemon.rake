namespace :streamer_daemon do
  desc "Stop the TweetStreamer daemon"
  task :stop do
    on roles(:app) do
      with RAILS_ENV: fetch(:rails_env) do
        within "#{fetch(:deploy_to)}/current/" do
          execute :bundle, :exec, 'bin/tweet_streamer', :stop
        end
      end
    end
  end

  desc "Start the TweetStreamer daemon"
  task :start do
    on roles(:app) do
      with RAILS_ENV: fetch(:rails_env) do
        within release_path do
          execute :bundle, :exec, 'bin/tweet_streamer', :start
        end
      end
    end
  end
end