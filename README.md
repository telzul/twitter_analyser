Twitter Analyser
================

## neo4j installieren:
    rake neo4j:install[community-2.1.5]

## Server starten
1. Neo4j starten

        rake neo4j:start
2. Server starten

        ./bin/rails server

3. Redis starten

		redis-server
4. Sidekiq starten

		RAILS_ENV=development bundle exec sidekiq

5. daemon starten

        RAILS_ENV=development bundle exec ./bin/tweet_streamer run


## Auf dem Server deployen

bundle exec cap staging deploy

## Tweet Streaming auf dem Server starten/stoppen

bundle exec cap staging streamer_daemon:[stop|start]

## Wichtige TODOs:
* Visualisierungen einbauen

